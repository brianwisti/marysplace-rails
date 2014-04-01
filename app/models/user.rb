require 'barby/barcode/code_128'
class User < ActiveRecord::Base
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

  def anonymize!
    self.name = self.anonymized_name
    self.email = self.anonymized_email
    self.login = self.anonymized_login
    self.last_login_ip = self.anonymized_last_login_ip
    self.current_login_ip = self.anonymized_current_login_ip

    # These affect multiple fields, so they get special methods.
    self.anonymize_password!
    self.anonymize_avatar!
  end

  # Names are obvious PII
  def anonymized_name
    Faker::Name.name
  end

  # Emails are obvious PII
  def anonymized_email
    Faker::Internet.email self.name
  end

  # Login names are strong candidates for PII
  def anonymized_login
    if self.client
      self.client.generate_login_code
    else
      Faker::Internet.user_name self.name
    end
  end

  # IP addresses are potential PII
  def anonymized_last_login_ip
    if self.login_count > 0
      Faker::Internet.ip_v4_address
    end
  end

  # IP addresses are potential PII
  def anonymized_current_login_ip
    if self.login_count > 0
      Faker::Internet.ip_v4_address
    end
  end

  # User avatars are strong candidates for PII
  # (Depending on organization policy they may be obvious PII)
  #
  # NOTE: Initial anonymization version just deletes avatar
  def anonymize_avatar!
    self.avatar = nil
  end

  # Simplify password for demo and anonymize to complicate
  # cracking real passwords.
  def anonymize_password!
    self.password = self.password_confirmation = '1234'
  end

end
