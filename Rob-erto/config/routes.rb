Rails.application.routes.draw do

  get 'help/index'
  get 'home/index'
  root 'home#index'

  post '/send_msg', to: 'home#send_msg'     # per invocare send_msg di HomeController dalla view 
  get 'get_usr_input', to: 'home#get_usr_input'      # per invocare get_usr_input di HomeController da home.js.erb

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
