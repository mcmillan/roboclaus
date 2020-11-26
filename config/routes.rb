Rails.application.routes.draw do
  devise_for :users

  resources :groups do
    resources :invitations, only: %i[create]
  end

  root to: 'landing#index'
end
