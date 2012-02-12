require 'resque/server'
Reader::Application.routes.draw do
  devise_for :users

  namespace :users do
    resources :subscriptions
  end

  resources :feeds do
    resources :items
    collection do
      get :refresh
    end
  end

  resources :items do
    put :read
  end

  mount Resque::Server.new, :at => "/resque"
  root :to => 'home#index'
end
