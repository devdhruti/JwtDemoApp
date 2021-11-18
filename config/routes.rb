Rails.application.routes.draw do

  devise_for :users
  root "pages#index"
  
  namespace :api do
    namespace :v1 do
      
      resources :photos
      resources :albums

      devise_scope :user do
        get "/users" , to: "users#index"
        post "/users/sign_up", to: "registrations#create"
        post "/users/sign_in", to: "sessions#create"
        delete "/logout", to: "sessions#destroy"
        post "/confirm_email", to: "confirmations#confirm_email"
      end

    end
  end
end
