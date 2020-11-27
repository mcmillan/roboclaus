Rails.application.routes.draw do
  get 'group_users/destroy'
  devise_for :users

  resources :groups do
    resources :invitations, only: %i[create destroy]
    resources :group_users, path: :users, only: %i[destroy]

    member do
      post :match
    end
  end

  get '/terms' => 'static#terms'
  get '/privacy' => 'static#privacy'
  root to: 'landing#index'
end
