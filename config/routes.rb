Rails.application.routes.draw do

  root    'static_pages#home'
  get     'help',     to: 'static_pages#help'
  get     'contact',  to: 'static_pages#contact'
  get     'about',    to: 'static_pages#about'
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

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
