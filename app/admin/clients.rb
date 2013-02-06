ActiveAdmin.register Client do
  index do
    column "Client", sortable: :current_alias do |client|
      if client.is_active
        client.current_alias
      else
        em client.current_alias
      end
    end
    column "Points", :point_balance
    column "Status", sortable: :is_active do |client|
      if client.is_active
        "active"
      else
        em "inactive"
      end
    end


    default_actions
  end
end
