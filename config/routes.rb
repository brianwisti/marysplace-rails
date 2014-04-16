Marysplace::Application.routes.draw do

  resources :client_notes


  namespace :api, defaults: { format: :json } do
    namespace :v0 do
      resources :checkins, only: [ :create ]
      resources :catalog_items, only: [ :index ]
    end
  end

  resources :catalog_items


  get "store/index",
    as: 'store'
  get "store/cannot_shop"
  put "store/start"
  put "store/finish/:id" => 'store#finish',
    as: 'store/finish'
  get "store/open"
  put "store/add/:id" => 'store#add',
    as: 'store/add'
  delete "store/remove/:id" => 'store#remove',
    as: 'store/remove'
  put "store/change"
  get "store/show/:id" => 'store#show',
    as: 'store/show'

  resources :locations

  resources :messages

  resources :roles, only: [ :show ]

  resources :client_flags do
    member do
      get 'resolve'
      post 'resolve_store'
    end

    collection do
      get 'resolved'
      get 'unresolved'
    end
  end

  resources :checkins do
    collection do
      get 'selfcheck'
      put 'selfcheck_post'
      get 'today'
      get 'report/:year/:month/:day' => 'checkins#daily_report',
        constraints: {
          year: %r/\d{4}/,
          month: %r/\d\d?/,
          day: %r/\d\d?/
        },
        as: 'daily_report'
      get 'report/:year/:month' => 'checkins#monthly_report',
        constraints: {
          year: %r/\d{4}/,
          month: %r/\d\d?/,
        },
        as: 'monthly_report'
      get 'report/:year' => 'checkins#annual_report',
        constraints: {
          year: %r/\d{4}/,
        },
        as: 'annual_report'
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
      get 'all'
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
      get 'all'
      get 'search'
    end

    member do
      get 'card'
      get 'checkins'
      get 'entries'
      get 'entry'
      get 'flags'
      get 'new_login'
      get 'notes'
      put 'create_login'
      get 'purchases'
    end
  end

  get "welcome/index"
  resources :users, except: [ :destroy ] do
    member do
      get  'roles'
      post 'toggle_role'
      get  'entries'
    end
  end

  resources :password_resets,
    except: [ :destroy ]

  resource :user_session, only: [ :new, :create, :destroy ]

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
