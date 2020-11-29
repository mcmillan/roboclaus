Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  devise_for :users

  resources :invitations, only: %i[show]

  resources :groups do
    resources :invitations, only: %i[create destroy]
    resources :group_users, path: :users, only: %i[destroy]

    member do
      post :match
    end
  end

  get '/terms', to: 'static#terms'
  get '/privacy', to: 'static#privacy'
  get '404', to: 'static#not_found'

  root to: 'landing#index'
end
