require 'zlib' # TODO: Is there a better place to require this?

class Client < ActiveRecord::Base
  attr_accessible :added_by, :added_by_id, :birthday, :current_alias, 
    :full_name, :last_edited_by, :last_edited_by_id, :notes, :oriented_on, :other_aliases, 
    :phone_number, :point_balance, :is_active, :is_flagged

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

  has_many :points_entries
  has_many :checkins
  has_many :client_flags
  has_many :purchases,
    class_name: 'StoreCart',
    foreign_key: :shopper_id


  # TODO: Replace alias hack w/renaming the relationship.
  #       That means digging through templates too.
  alias :flags :client_flags

  before_save do
    self.point_balance ||= 0
  end

  def create_login(opts)
    password = opts[:password]
    confirmation = opts[:password_confirmation]
    username = self.generate_login_code
    self.login = User.create(login: username, password: password, password_confirmation: confirmation)
    self.save
  end

  # Generate a sufficiently unique login code
  #
  # short enough to type, but not just straight current_alias (which can change)
  def generate_login_code
    source = "RE|#{self.current_alias}|#{Time.now.to_i}"
    login_code = sprintf "%08x", Zlib.crc32(source)
    return login_code
  end

  # Does this client have unresolved flags?
  def is_flagged?
    return self.flags.unresolved.count > 0
  end

  # Can this client make purchases?
  def can_shop?
    return self.flags.unresolved.where(can_shop: false).count == 0
  end

  # Should this client be blocked from entry?
  def is_blocked?
    return self.flags.unresolved.where(is_blocking: true).count > 0
  end

  def update_points!
    entries_total = self.points_entries.sum(:points)
    purchase_total = self.purchases.where('finished_at is not null').sum(:total)
    new_balance = entries_total - purchase_total
    self.update_attributes(point_balance: new_balance)
  end

  def self.quicksearch(query)
    query = query.strip
    starts_with = "#{query}%"
    ends_with = "%#{query}"
    contains = "%#{query}%"
    where('(current_alias = ? or current_alias ilike ? or current_alias ilike ? or current_alias ilike ? or other_aliases ilike ? or other_aliases ilike ? or other_aliases ilike ?) and is_active = true',
          query, starts_with, ends_with, contains, starts_with, ends_with, contains)
      .order(:current_alias)
  end

end
