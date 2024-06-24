
Rails.application.routes.draw do

  get 'amici/index'
  get 'profilo/index'
  get 'help/index'
  get 'home/index'
  root 'home#index'

  resource :chat
  post 'create_chat', to: 'home#create_chat', as: 'create_chat'#per creare chat eventualmente quando si fa la logica
  get 'mostra_chat/:chat_id', to: 'home#mostra_chat', as: 'mostra_chat'
  patch 'cambia_nome_chat/:chat_id', to: 'home#cambia_nome_chat', as: 'cambia_nome_chat'
  post '/send_msg', to: 'home#send_msg'     # per invocare send_msg di HomeController dalla view
  post '/invia_domanda/:domanda', to:'home#invia_domanda', as: 'invia_domanda'
  get 'change_theme', to: 'application#change_theme'  # per cambiare il tema

  delete '/home/:id/delete_message', to: 'home#delete_message', as: :delete_message  # per eliminare un messaggio
  delete '/home/:id/delete_chat', to: 'home#delete_chat', as: :delete_chat
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
  resources :amici do
    member do
      put :accept
      delete :destroy
    end
  end

end
