Rails.application.routes.draw do
  resources :wallets
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "/sign_up", to: "signup#register"

  namespace :user, shallow: true do
      post :login
      put :update_password
  end

end
