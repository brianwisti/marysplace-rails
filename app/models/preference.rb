class PreferencesValidator < ActiveModel::Validator
  def validate record
    fields = record.client_fields
    fields.each do |field|
      unless Client.column_names.include? field
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
      [ 'current_alias', 'point_balance', 'created_at' ]
    end
  end
end
