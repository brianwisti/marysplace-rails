require 'anonymizable'
require 'barby/barcode/code_128'

class User < ActiveRecord::Base
  extend Anonymizable
  include HasBarcode

  attr_accessible :login, :name, :email, :password, :password_confirmation, :avatar, :avatar_file_name, :last_message_check
  attr_accessor :avatar

  acts_as_authentic do |c|
    c.login_field = 'login'
    c.validate_email_field = false
  end

  has_and_belongs_to_many :roles
  has_many :checkins
  has_many :points_entries,
    foreign_key: :added_by_id

  # Some users are also clients
  has_one :client,
    foreign_key: :login_id

  has_attached_file :avatar,
    styles: {
      thumb:  '100x100>',
      square: '200x200#',
      medium: '300x300>'
    },
    default_url: "https://s3.amazonaws.com/elasticbeanstalk-us-east-1-820256515611/marys-place/avatars/:style/blank.png"

  has_barcode :barcode,
    outputter: :svg,
    type: Barby::Code128B,
    value: Proc.new { |u| u.login }

  delegate :current_alias,
    to:     :client,
    prefix: true

  def messages_checked!
    self.update_attributes(last_message_check: DateTime.now)
    self.reload
  end

  def role?(role)
    self.roles.exists?( name: role.to_s )
  end

  def toggle_role role
    if self.role? role
      self.roles.delete role
    else
      self.roles.push role
    end
  end

  def deliver_password_reset_instructions!
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
