ActiveAdmin.register User do
  index do
    column "Name",  :name
    column "Login", :login
    column "Email", :email
    column "Added At", :created_at
    column "Last Login", :last_login_at

    default_actions
  end

  show do |user|
    attributes_table do
      row :name
      row :login
      row :email
      row :login_count
      row :current_login_at
      row :current_login_ip
      row :last_request_at
      row :last_login_at
      row :last_login_ip
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
