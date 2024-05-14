Rails.application.routes.draw do

  get 'index' => 'home#index'
  root 'home#index'
  get 'help' => 'help#help'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
