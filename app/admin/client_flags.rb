ActiveAdmin.register ClientFlag do
  index do
    column "Client" do |flag|
      flag.client.current_alias
    end
    column :is_blocking
    column :created_at
    column :expires_on
    column :resolved_on

    default_actions
  end

  show do
    attributes_table do
      row :id
      row "Client" do |flag|
        link_to flag.client.current_alias, admin_client_path(flag.client)
      end
      row :expires_on
      row :is_blocking
      row :description
      row :consequence
      row :action_required
      row :resolved_on
      row :resolved_by
      row :resolution
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
