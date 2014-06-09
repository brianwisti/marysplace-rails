class AddCardTemplateToOrganizations < ActiveRecord::Migration
  def self.up
    add_attachment :organizations, :card_template
  end

  def self.down
    remove_attachment :organizations, :card_template
  end
end
