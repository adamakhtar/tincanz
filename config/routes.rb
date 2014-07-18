Tincanz::Engine.routes.draw do
  
  namespace :tincanz do
  namespace :admin do
    get 'messages/create'
    end
  end

  namespace :admin do
    resources :users, only: [:index, :show]
    resources  :conversations, only: [:index, :show]
    resources  :messages, only: [:create]
  end

end
