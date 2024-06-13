
Rails.application.routes.draw do

  get 'amici/index'
  get 'profilo/index'
  get 'help/index'
  get 'home/index'
  root 'home#index'

  post '/create', to: 'home#create' #per creare chat eventualmente quando si fa la logica

  post '/send_msg', to: 'home#send_msg'     # per invocare send_msg di HomeController dalla view

  get 'change_theme', to: 'application#change_theme'  # per cambiare il tema

  delete '/home/:id/delete_message', to: 'home#delete_message', as: :delete_message  # per eliminare un messaggio

  get 'set_aimodel/:ai_model', to: 'home#set_aimodel', as: 'set_aimodel'  # per settare il modello di IA

  patch '/users/update_nickname', to: 'users#update_nickname', as: 'update_nickname' # per aggiornare il nickname

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'callbacks', sessions: 'sessions' }
  #change the route from /users/login to /login route
  devise_scope :user do
    get 'login', to: 'sessions#new'
  end
  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
  end

  patch 'users/:id/update_profile_image', to: 'profilo#update_profile_image' # per aggiornare l'immagine del profilo

  resources :users do
    get 'amici', on: :collection
  end

  resources :amici

end
