class Preference < ActiveRecord::Base
  attr_accessible :user_id, :client_fields

  validates :user_id,
    presence: true

  belongs_to  :user

  def self.default_for preference
    case preference.to_sym
    when :client_fields
      [ 'current_alias', 'point_balance', 'created_at' ]
    end
  end
end
