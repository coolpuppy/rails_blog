Rails.application.routes.draw do
  get 'relationships/create'

  get 'relationships/destroy'

  get     '/login', to: 'sessions#new'
  post    '/login', to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get :followings, :followers
    end
  end

  resources :users
  resources :relationships, only: [:create, :destroy]
  resources :blogs
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
