ActiveAdmin.register PointsEntry do
  csv options: { force_quotes: true } do
    column :performed_on
    column("Client") { |entry| entry.client.current_alias }
    column("Type") { |entry| entry.points_entry_type.name }
    column :bailed
    column :points
    column("Added By") { |entry| entry.added_by.login }
  end

  index do
    column "Performed On", :performed_on
    column "Client" do |entry|
      link_to entry.client.current_alias, admin_client_path(entry.client)
    end
    column "Type" do |entry|
      link_to entry.points_entry_type.name, admin_points_entry_type_path(entry.points_entry_type)
    end
    column "Bailed", :bailed
    column "Points", :points
    column "Added By" do |entry|
      link_to entry.added_by.login, admin_user_path(entry.added_by)
    end
    default_actions
  end
end
