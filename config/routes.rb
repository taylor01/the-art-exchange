Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Authentication routes
  get "sign_in", to: "sessions#new", as: :new_session
  post "sign_in", to: "sessions#create", as: :sessions
  delete "sign_out", to: "sessions#destroy", as: :destroy_session

  get "sign_up", to: "registrations#new", as: :new_registration
  post "sign_up", to: "registrations#create", as: :registrations

  get "verify", to: "otp#show", as: :otp_verification
  post "verify", to: "otp#create", as: :verify_otp
  post "verify/resend", to: "otp#resend", as: :resend_otp

  get "confirm/:token", to: "confirmations#show", as: :confirmation
  get "resend_confirmation", to: "confirmations#new", as: :resend_confirmation
  post "resend_confirmation", to: "confirmations#create", as: :confirmations
  get "confirmation_sent", to: "confirmations#sent", as: :confirmation_sent

  get "forgot_password", to: "password_resets#new", as: :new_password_reset
  post "forgot_password", to: "password_resets#create", as: :password_resets
  get "reset_password/:id", to: "password_resets#show", as: :password_reset
  patch "reset_password/:id", to: "password_resets#update", as: :update_password_reset

  # Omniauth callbacks
  get "/auth/:provider/callback", to: "omniauth_callbacks#:provider"
  get "/auth/failure", to: "omniauth_callbacks#failure"

  # User profile management
  get "profile", to: "profiles#show", as: :profile
  get "profile/edit", to: "profiles#edit", as: :edit_profile
  patch "profile", to: "profiles#update", as: :update_profile

  # Poster routes with slug support
  resources :posters, only: [ :index, :show ], param: :id_or_slug do
    member do
      post :add_to_collection
      delete :remove_from_collection
    end
    collection do
      post :create_search_share
    end
  end

  # Legacy URL redirects - redirect old /artworks URLs to new /posters URLs
  get "artworks", to: redirect("/posters")
  get "artworks/:id", to: redirect { |params, req| 
    begin
      poster = Poster.find(params[:id])
      "/posters/#{poster.to_param}"
    rescue ActiveRecord::RecordNotFound
      "/posters"
    end
  }

  # Search short URLs
  get "s/:token", to: "search#show", as: :search_share

  # User collection management
  resources :user_posters, only: [ :index, :edit, :update, :destroy ]

  # Admin routes
  get "admin", to: "admin#index", as: :admin_dashboard
  namespace :admin do
    resources :posters
  end

  # Root route
  root "home#index"
end
