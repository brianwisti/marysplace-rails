class User < ActiveRecord::Base
  attr_accessible :login, :name, :email, :password, :password_confirmation
  acts_as_authentic do |c|
    c.login_field = 'login'
    c.validate_email_field = false
  end

  has_and_belongs_to_many :roles
  has_many :checkins
  has_many :points_entries,
    foreign_key: :added_by_id

  def role?(role)
    self.roles.exists?( name: role.to_s )
  end

end
