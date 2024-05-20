Rails.application.routes.draw do

  get 'profilo/index'
  get 'help/index'
  get 'home/index'
  root 'home#index'

  post '/send_msg', to: 'home#send_msg'     # per invocare send_msg di HomeController dalla view

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users,:controllers => {registrations: 'registrations'}
  #change the route from /users/login to /login route
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end
  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
  end

end
