require 'anonymizable'
require 'zlib' 
require 'barby'
require 'barby/outputter/svg_outputter'
require 'barby/barcode/code_128'

class Client < ActiveRecord::Base
  extend Anonymizable
  include HasBarcode

  attr_accessible :added_by, :added_by_id, :birthday, :current_alias,
    :full_name, :last_edited_by, :last_edited_by_id, :notes, :oriented_on,
    :other_aliases, :phone_number, :point_balance, :is_active, :is_flagged,
    :signed_covenant, :email_address, :emergency_contact, :case_manager_info,
    :family_info, :medical_info, :staying_at, :mailing_list_address, 
    :on_mailing_list, :personal_goal, :community_goal, :checkin_code,
    :picture, :picture_file_name

  attr_accessor :picture

  has_attached_file :picture,
    styles: {
      thumb:  '100x100>',
      square: '200x200#',
      medium: '300x300>'
    },
    default_url: "https://s3.amazonaws.com/elasticbeanstalk-us-east-1-820256515611/marys-place/pictures/:style/blank.png"

  validates_attachment :picture,
    content_type: {
      content_type: %w( image/jpeg image/png image/gif )
    }

  has_barcode :barcode,
    outputter: :svg,
    type: Barby::Code128B,
    value: Proc.new { |c| c.checkin_code }

  def bare_barcode
    barcode = Barby::Code128B.new( self.checkin_code )
    svg_options = {
      height: 30,
      ymargin: 72,
      xmargin: 5
    }

    barcode.bars_to_path svg_options
  end

  validates :current_alias,
    presence: true,
    uniqueness: true
  validates :added_by_id,
    presence: true

  belongs_to :added_by,
    class_name: "User"
  belongs_to :last_edited_by,
    class_name: "User"
  belongs_to :login,
    class_name: "User"

  belongs_to :organization

  has_many :points_entries,
    dependent: :destroy
  has_many :checkins,
    dependent: :destroy
  has_many :client_flags,
    dependent: :destroy
  has_many :purchases,
    class_name: 'StoreCart',
    foreign_key: :shopper_id,
    dependent: :destroy
  has_many :staff_notes,
    class_name: 'ClientNote',
    dependent: :destroy

  delegate :login,
    to:     :added_by,
    prefix: true
  delegate :login,
    to: :last_edited_by,
    prefix: true

  # TODO: Replace alias hack w/renaming the relationship.
  #       That means digging through templates too.
  alias :flags :client_flags

  # The generated barcode used for automated checkin
  def barcode(args={})
    self.bare_barcode
  end

  # The generated code used for automated checkin
  def login_code
    self.login.login
  end

  def self.cannot_shop
    now = Time.now
    find_by_sql [ %{
        select clients.*
          from clients
        left outer join client_flags cf
          on cf.client_id = clients.id
        left outer join store_carts sc
          on sc.shopper_id = clients.id
        left outer join points_entries pe
          on pe.client_id = clients.id
        left outer join points_entry_types pet
          on pet.id = pe.points_entry_type_id
        where (
          ( cf.is_blocking is null or cf.is_blocking = 'f' )
          and cf.can_shop = 'f'
          and (
            ( cf.resolved_on is null and cf.expires_on is null )
            or
            ( cf.resolved_on is null and cf.expires_on > now() )
          )
        )
        or (
          sc.finished_at between ? and ?
        )
        or (
          pet.name = 'Purchase'
          and pe.performed_on between ? and ?
        )
        group by clients.id
        order by clients.current_alias
      }, now.beginning_of_week, now, now.beginning_of_week, now ]
  end

  before_save do
    self.point_balance ||= 0

    unless self.organization
      if self.added_by.organization
        self.organization = self.added_by.organization
      end
    end
  end

  # Generate a sufficiently unique checkin code
  #
  # short enough to type, but not just straight current_alias
  # (which can change)
  def generate_login_code
    source = "RE|#{self.current_alias}|#{Time.now.to_i}"
    login_code = sprintf "%08x", Zlib.crc32(source)
    return login_code
  end

  def update_checkin_code!
    self.update_attributes checkin_code: self.generate_login_code
  end

  # part of deprecation process for client logins
  alias_method :generate_checkin_code, :generate_login_code

  # Does this client have unresolved flags?
  def is_flagged?
    return self.flags.unresolved.count > 0
  end

  # Does this client have an open StoreCart?
  def is_shopping?
    return self.purchases.where('finished_at is null').count > 0
  end

  # The current open cart for this client, or nothing.
  def cart
    return self.purchases.where('finished_at is null').first
  end

  # Can this client make purchases?
  def can_shop?
    if self.flags.unresolved.where(can_shop: false).count > 0
      return false
    end

    return true unless self.has_shopped?

    now = Time.now
    if self.last_shopped_at < now.beginning_of_week
      return true
    end

    return false
  end

  # Should this client be blocked from entry?
  def is_blocked?
    return self.flags.unresolved.where(is_blocking: true).count > 0
  end

  # Have I ever shopped?
  def has_shopped?
    self.purchases.count > 0 || self.has_purchase_entry?
  end

  # When was my last completed shopping trip?
  def last_shopped_at
    last_purchase = self.last_purchase
    last_purchase_entry = self.last_purchase_entry

    if last_purchase && last_purchase_entry
      [last_purchase, last_purchase_entry].max
    elsif last_purchase
      last_purchase
    elsif last_purchase_entry
      last_purchase_entry
    end
  end

  def has_purchase_entry?
    purchase_type = PointsEntryType.where(name: 'Purchase').first
    self.points_entries.where(points_entry_type_id: purchase_type).count > 0
  end

  def last_purchase
    if self.purchases.count > 0
      self.purchases.order('finished_at DESC').first.finished_at
    end
  end

  def last_purchase_entry
    if self.has_purchase_entry?
      purchase_type = PointsEntryType.where(name: 'Purchase').first
      self.points_entries.where(points_entry_type_id: purchase_type)
        .last.performed_on.to_time
    end
  end

  def to_hash
    { id: self.id,
      current_alias: self.current_alias,
      other_aliases: self.other_aliases,
      point_balance: self.point_balance,
      is_flagged:    self.is_flagged?,
      can_shop:      self.can_shop?
    }
  end

  def update_points!
    entries_total = self.points_entries.sum(:points)
    purchase_total = self.purchases.where('finished_at is not null')
      .sum(:total)
    new_balance = entries_total - purchase_total
    self.update_attributes(point_balance: new_balance)
  end

  def self.filtered_by filters
    filters.delete_if { |k,v| v.empty? }

    if filters.nil? 
      filters = { is_active: true }
    end

    filtered = self
    if is_active = filters[:is_active]
      filtered = filtered.where(is_active: is_active)
    else
      filtered = filtered.where(is_active: true)
    end

    if has_picture = filters[:has_picture]
      if has_picture == "true"
        filtered = filtered.where('picture_file_name is not null')
      elsif has_picture == "false"
        filtered = filtered.where('picture_file_name is null')
      end
    end

    return filtered
  end

  def self.quicksearch(query)
    unless query
      return []
    end

    query        = query.strip
    starts_with  = "#{query}%"
    ends_with    = "%#{query}"
    contains     = "%#{query}%"
    sql_fragment = %{
      (current_alias = ?
       or current_alias ilike ?
       or current_alias ilike ?
       or current_alias ilike ?
       or other_aliases ilike ?
       or other_aliases ilike ?
       or other_aliases ilike ?)
      and is_active = true
    }

    where(sql_fragment,
      query, starts_with, ends_with, contains, starts_with, ends_with,
      contains)
      .order(:current_alias)
  end

  # Fill my identifying fields with fake data
  # 
  # Replaces fields in the client but does not save them. That allows the one 
  # "maybe" production usage: anonymized display of clients.
  anonymizes(:full_name) { Faker::Name.name }

  anonymizes :oriented_on do |client|
    if client.points_entries.size > 0
      client.points_entries.order(:performed_on).last.performed_on
    end
  end

  anonymizes(:phone_number) { Faker::PhoneNumber.phone_number }
  
  anonymizes :birthday do 
    # Reasonable age range is 18-90.
    # TODO: simulate clients that are children of other clients.
    age = Random.rand(18..90)
    offset = Random.rand(0..365) # So everyone doesn't magically share the same birthday
    age.years.ago + offset.days
  end

  anonymizes(:notes) { Faker::Lorem.paragraphs(Random.rand(0..3)).join }

  anonymizes :current_alias  do |client|
    names = client.full_name.split ' '
    usual_pattern = "#{names.shift} " + names.map { |name| "#{name[0]}." }.join(' ')
    if Client.where(current_alias: usual_pattern).count == 0
      usual_pattern
    elsif Client.where(current_alias: client.full_name).count == 0
      client.full_name
    else
      "#{client.full_name} #{client.id}"
    end
  end

  anonymizes(:other_aliases) { '' }
end
