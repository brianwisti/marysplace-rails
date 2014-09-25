require 'anonymizable'
require 'barby'
require 'barby/outputter/svg_outputter'
require 'barby/barcode/code_128'

# Anything that can directly use this application.
# 
# Usually but not necessarily a person.
class User < ActiveRecord::Base
  extend Anonymizable
  include HasBarcode

  attr_accessor :avatar

  acts_as_authentic do |config|
    config.login_field          = 'login'
    config.validate_email_field = false
  end

  has_and_belongs_to_many :roles
  belongs_to :organization
  has_many :checkins
  has_many :points_entries,
    foreign_key: :added_by_id

  has_one :preference

  # Some users are also clients
  has_one :client,
    foreign_key: :login_id

  has_attached_file :avatar,
    styles: {
      thumb:  '100x100>',
      square: '200x200#',
      medium: '300x300>'
    },
    default_url: "https://s3.amazonaws.com/" +
                 "elasticbeanstalk-us-east-1-820256515611/" +
                 "marys-place/avatars/:style/blank.png"

  validates_attachment :avatar,
    content_type: {
      content_type: %w( image/jpeg image/png image/gif )
    }

  has_barcode :barcode,
    outputter: :svg,
    type: Barby::Code128B,
    value: Proc.new { |user| user.login }

  def bare_barcode
    barcode = Barby::Code128B.new( self.login )
    svg_options = {
      height: 30,
      ymargin: 72,
      xmargin: 5
    }

    barcode.bars_to_path svg_options
  end

  delegate :current_alias,
    to:     :client,
    prefix: true
  delegate :name,
    to:     :organization,
    prefix: true

  def messages_checked
    self.update_attributes(last_message_check: DateTime.now)
    self.reload
  end

  # True if user has accepted a role named role_name
  def role? role_name
    self.roles.exists? name: role_name.to_s
  end

  # Ask the user to take on a new role.
  def accept_role role
    self.roles.push role
  end

  # Ask the user to stop acting as a role
  def withdraw_role role
    self.roles.delete role
  end

  # Accept a collection of roles, withdrawing any not present
  def establish_roles specified_roles
    # TODO: Separate cleanup method / script to take care of duplicate
    #       User<->Role connections rather than `delete_all` here.
    self.roles.delete_all
    self.roles = specified_roles
  end

  # Get user preference for setting, or default if not set.
  def preference_for setting

    if preferences = self.preference
      pref = preferences.attributes[setting.to_s]
      return pref unless pref.empty?
    end

    Preference.default_for setting
  end

  # Store user preference hash for later access
  def remember_preference settings
    self.preference = Preference.find_or_create_by user_id: self
    self.preference.update settings
  end

  def deliver_password_reset_instructions
    reset_perishable_token!
    UserMailer.password_reset_notification(self).deliver
  end

  # Names are obvious PII
  anonymizes :name do
    Faker::Name.name
  end

  # Emails are obvious PII
  anonymizes :email do
    Faker::Internet.email self.name
  end

  # Login names are strong candidates for PII
  anonymizes :login do |user|
    if user.client
      user.client.generate_login_code
    else
      Faker::Internet.user_name user.name
    end
  end

  # IP addresses are potential PII
  anonymizes :last_login_ip do |user|
    if user.login_count > 0
      Faker::Internet.ip_v4_address
    end
  end

  # IP addresses are potential PII
  anonymizes :current_login_ip do |user|
    if user.login_count > 0
      Faker::Internet.ip_v4_address
    end
  end

  # User avatars are strong candidates for PII
  # (Depending on organization policy they may be obvious PII)
  #
  # NOTE: Initial anonymization version just deletes avatar
  anonymization_rule :avatar do |user|
    user.avatar = nil
  end

  # Simplify password for demo and anonymize to complicate
  # cracking real passwords.
  anonymization_rule :password do |user|
    user.password = user.password_confirmation = '1234'
  end

end
