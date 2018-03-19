Rails.application.routes.draw do
  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :schemas, param: :uuid
  resources :projects, param: :uuid
end
