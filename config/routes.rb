Marysplace::Application.routes.draw do

  resources :organizations

  resources :client_notes


  namespace :api, defaults: { format: :json } do
    namespace :v0 do
      resources :checkins, only: [ :create ]
    end
  end

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

  resources :points_entry_types do
    collection do
      get 'search'
      get 'all'
      get 'unpaged'
    end

    member do
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
      get 'barcode'
      get 'card'
      post 'checkin_code'
      get 'checkins'
      get 'entries'
      get 'entry'
      get 'flags'
      get 'notes'
      get 'purchases'
    end
  end

  get "welcome/index"
  resources :users, except: [ :destroy ] do
    member do
      get  'entries'
      post 'preference'
    end
  end

  resources :password_resets,
    except: [ :destroy ]

  resource :user_session, only: [ :new, :create, :destroy ]

  get 'login' => 'user_sessions#new', as: :login
  delete 'logout' => 'user_sessions#destroy', as: :logout

  root :to => 'welcome#index'
end
