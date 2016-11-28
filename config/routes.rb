Rails.application.routes.draw do

  get 'ui/index'

  get 'ui/show'

  use_doorkeeper do
    controllers :applications => 'oauth/applications' do
    end
  end

  root to: "welcome#index"

  get "/evangelists" => "welcome#evangelists"

  post "/send_mail" => "welcome#mail", as: "contact_from"

  post "/evangelist_send_mail" => "welcome#evangelist_mail", as: "evangelist_form"

  get "/confirm/:user_id/:token" => "users#confirm", as: "confirm"

  get "/reset_password/:id/:token" => "passwords#edit", as: "reset_password"

  get "/forgot_password" => "passwords#new"

  get "/unauthorized" => "users#unauthorized", as: "unauthorized"

  get "/no_developer" => "oauth/applications#no_developer", as: "no_developer"

  get "/first_app" => "oauth/applications#first_app", as: "first_app"

  resource :user
  resource :session

  resources :applications, only: [] do
    namespace :measurement do
      resources :step_measurements, only: [:index]
      resources :bpm_measurements, only: [:index]
      resources :height_measurements, only: [:index]
      resources :weight_measurements, only: [:index]
      resources :blood_pressure_measurements, only: [:index]
      resources :blood_oxygen_measurements, only: [:index]
      resources :body_fat_measurements, only: [:index]
      resources :bmr_measurements, only: [:index]
      resources :bmi_measurements, only: [:index]
    end
    namespace :user_data do
      resources :users, only: [:index] do
        collection do
          get :parse
        end
      end
    end

    resources :alerts do
      collection do
        get :certificate
        patch :upload_certificate
      end
    end
    resources :cloud_codes, only: :create

    resources :medical_devices
  end

  resources :parse_apps


  resources :medical_devices do
    resources :device_results
  end

  resource :passwords, only: [:create]

  resources :developers

  get "/developer/logout" => "developer/sessions#destroy", :as => "logout"
  get "/developer/login" => "developer/sessions#new", as: "login"

  # omniauth
  get "/auth/github/callback" => "developer/sessions#create"
  get "/auth/:provider/callback" => "omniauth#create"

  get "/auth/failure" => "omniauth#failure"

  # humanapi
  get "apps"            => "humanapi#new"
  post "humanapi"       => "humanapi#create"

  namespace :developer do
    resource :session
  end

  resources :subscription do
    resource :purchase
  end

  # stripe webhooks
  post "purchases/webhook"

  resources :services do
    resource :capabilities
    member do
      patch :toggle
    end
  end

  resources :collaborations

  resources :profiles

  api_version(:module => "V3", :path => {:value => "v3"}) do

    get "go-go-gorby-status" => "status#show"

    mount Nu::Engine, at: "/nu"
    mount Measurement::Engine, at: "/measurement"

    namespace :admin do
      resource :kpis
      resources :users
    end

    post 'auth.(:format)' => 'auth#create', as: "auth"
    post 'pusher/auth' => 'auth#pusher'
    resource :update_password, only: :update
    resource :reset_password, only: :create
    resources :users, only: :create
    resource :profile, only: [:show, :update, :destroy]
    get "searches" => "searches#index"
    resources :medical_devices do
      resources :column_values
      resources :device_results do
        collection do
          get :query
        end
        collection do
          post :upload
        end
      end
    end
    resources :measurements
    resources :products do
      collection do
        get :search
      end
      resource :favourite, only: [:create, :destroy]
      resource :places
    end
    resources :favourites, only: :index
    resources :meals do
      collection do
        get :search
        get :all
      end
      resource :favourite, only: [:create, :destroy]
      resource :places
    end

    resources :places
    resources :meal_previews
    resources :eats do
      collection do
        get :today
      end
    end
    resources :usda_ingredients
    resources :simple_ingredients
    resources :ingredient_groups
    resources :teams do
      resource :membership, only: :destroy
      resources :memberships
      resources :invitations
      resources :notifications
    end
    resources :devices
    resources :apps

    match "*path", to: -> (env) { [404, {}, ['{"error": {"message": "The URL you have requested was not found."}}']] }, via: :all

  end

  api_version(:module => "V2", :path => {:value => "v2"}) do
    mount Nu::Engine, at: "/nu"
  end

  api_version(:module => "V1", :path => {:value => "v1"}) do

    get "go-go-gorby-status" => "status#show"

    mount Nu::Engine, at: "/nu"
    mount Measurement::Engine, at: "/measurement"

    namespace :admin do
      resource :kpis
      resources :users
    end

    post 'auth.(:format)' => 'auth#create', as: "auth"
    post 'pusher/auth' => 'auth#pusher'
    resource :update_password, only: :update
    resource :reset_password, only: :create
    resources :users, only: :create
    resource :profile, only: [:show, :update, :destroy]
    get "searches" => "searches#index"
    resources :products do
      resource :favourite, only: [:create, :destroy]
      resource :places
    end
    resources :favourites, only: :index
    resources :meals do
      collection do
        get :all
      end
      resource :favourite, only: [:create, :destroy]
      resource :places
    end

    resources :places
    resources :meal_previews
    resources :eats do
      collection do
        get :today
      end
    end
    resources :ingredient_groups
    resources :teams do
      resource :membership, only: :destroy
      resources :memberships
      resources :invitations
      resources :notifications
    end
    resources :devices
    resources :apps

    match "*path", to: -> (env) { [404, {}, ['{"error": {"message": "The URL you have requested was not found."}}']] }, via: :all

  end


  if Rails.env.development?
    get "/ui" => "ui#index"
    get "/ui/:name" => "ui#show"
  end

end
