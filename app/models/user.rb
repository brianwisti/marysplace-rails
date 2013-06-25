require 'barby/barcode/code_128'
class User < ActiveRecord::Base
  include HasBarcode

  attr_accessible :login, :name, :email, :password, :password_confirmation, :avatar, :avatar_file_name
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

  def role?(role)
    self.roles.exists?( name: role.to_s )
  end

end
