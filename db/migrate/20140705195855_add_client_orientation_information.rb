class AddClientOrientationInformation < ActiveRecord::Migration
  def change
    add_column :clients, :case_manager_info, :string
    add_column :clients, :family_info, :text
    add_column :clients, :community_goal, :text
    add_column :clients, :email_address, :string
    add_column :clients, :emergency_contact, :string
    add_column :clients, :medical_info, :text
    add_column :clients, :mailing_list_address, :text
    add_column :clients, :personal_goal, :text
    add_column :clients, :signed_covenant, :boolean, default: false
    add_column :clients, :staying_at, :text
    add_column :clients, :on_mailing_list, :boolean, default: false
  end
end
