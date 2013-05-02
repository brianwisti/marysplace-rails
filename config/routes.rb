Marysplace::Application.routes.draw do
  ActiveAdmin.routes(self)

  resources :client_flags do
    member do
      get 'resolve'
      post 'resolve_store'
    end
  end

  resources :checkins do
    collection do
      get 'selfcheck'
      put 'selfcheck_post'
      get 'today'
      get 'on/:year/:month/:day' => 'checkins#on',
        constraints: {
          year: %r/\d{4}/,
          month: %r/\d\d?/,
          day: %r/\d\d?/
        },
        as: 'on'
      get 'report/:year/:month/:day' => 'checkins#report',
        constraints: {
          year: %r/\d{4}/,
          month: %r/\d\d?/,
          day: %r/\d\d?/
        },
        as: 'daily_report'
      get 'report/:year/:month' => 'checkins#report',
        constraints: {
          year: %r/\d{4}/,
          month: %r/\d\d?/,
        },
        as: 'monthly_report'
      get 'report/:year' => 'checkins#report', 
        constraints: {
          year: %r/\d{4}/,
        },
        as: 'annual_report'
      get 'report'
    end
  end

  resources :points_entries
  resources :signup_lists do
    collection do
      get 'new_for'
    end
  end

  resources :points_entry_types do
    collection do
      get 'search'
    end

    member do
      get 'signup_lists'
      get 'signup_list'

      get 'entry'
      get 'report/:year/:month/:day' => 'points_entry_types#report',
        constraints: {
          year: %r/\d{4}/,
          month: %r/\d\d?/,
          day: %r/\d\d?/
        },
        as: 'daily_report'
      get 'report/:year/:month' => 'points_entry_types#report',
        constraints: {
          year: %r/\d{4}/,
          month: %r/\d\d?/,
        },
        as: 'monthly_report'
      get 'report/:year' => 'points_entry_types#report', 
        constraints: {
          year: %r/\d{4}/,
        },
        as: 'annual_report'
      get 'report'
    end
  end

  resources :clients do
    collection do
      get 'search'
    end

    member do
      get 'checkins'
      get 'entries'
      get 'entry'
      get 'flags'
      get 'new_login'
      put 'create_login'
    end
  end

  get "welcome/index"
  resources :users do
    member do
      get  'roles'
      post 'toggle_role'
      get  'entries'
    end
  end

  resources :users

  resource :user_session

  match 'login' => 'user_sessions#new', as: :login
  match 'logout' => 'user_sessions#destroy', as: :logout

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
