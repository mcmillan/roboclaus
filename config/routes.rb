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
  %w[404 422 500].each do |code|
    get code, to: 'static#error', code: code
  end

  root to: 'landing#index'
end
