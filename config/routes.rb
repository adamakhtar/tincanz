Tincanz::Engine.routes.draw do

  resources :conversations, only: [:index, :show, :new, :create]

  namespace :admin do
    resources :users, only: [:index, :show]
    resources  :conversations, only: [:index, :show]
    resources  :messages, only: [:new, :create]
  end

end
