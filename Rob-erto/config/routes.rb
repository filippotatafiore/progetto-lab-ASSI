Rails.application.routes.draw do

  get 'help/index'
  get 'home/index'
  root 'home#index'

  post '/send_msg', to: 'home#send_msg'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
