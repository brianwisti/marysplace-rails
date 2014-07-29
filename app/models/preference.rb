class PreferencesValidator < ActiveModel::Validator
  def validate record
    valid_fields = Client.column_names + [ "picture" ]

    fields = record.client_fields
    fields.each do |field|
      unless valid_fields.include? field
        record.errors[:client_fields] << "#{field} is not a valid client field"
      end
    end
  end
end

class Preference < ActiveRecord::Base
  attr_accessible :user, :user_id, :client_fields

  validates :user_id,
    presence: true,
    uniqueness: true

  validates_with PreferencesValidator
  belongs_to  :user

  def self.default_for preference
    case preference.to_sym
    when :client_fields
      [ 'point_balance', 'created_at' ]
    end
  end
end
