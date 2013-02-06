ActiveAdmin.register PointsEntryType do
  index do
    column "Name", :name
    column "Default Points", :default_points
    column "Is Active", :is_active
    default_actions
  end
end
