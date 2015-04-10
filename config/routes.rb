Rails.application.routes.draw do
  resources :subscriptions

  root 'static_pages#home'

  devise_for :users, :controllers => { :registrations => "registrations" }

  get 'tutorial' => 'static_pages#tutorial'

  get 'faq' => 'static_pages#faq'

  get 'contact' => 'static_pages#contact'

  get 'auth/:provider/callback', to: 'authentication#create'
  get 'logout', to: 'authentication#destroy'

  get 'auth_facebook', to:'authentication#facebook_auth'

  get 'app', to:'main#index'
  post 'search', to:'main#search'
  post 'process_group', to:'main#process_group'
end
