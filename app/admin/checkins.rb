ActiveAdmin.register Checkin do
  index do
    column "Client" do |checkin|
      checkin.client.current_alias
    end
    column "Checked In At", :checkin_at
    column "By" do |checkin|
      checkin.user.login
    end

    default_actions
  end

  show do
    attributes_table do
      row :id
      row "Client" do |checkin|
        link_to checkin.client.current_alias, admin_client_path(checkin.client)
      end
      row :user_id
      row :notes
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :client, as: :select, collection: Hash[Client.all.map{|c| [c.current_alias, c.id] }]
      f.input :notes
    end
    f.actions
  end
end
