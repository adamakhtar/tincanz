Tincanz::Engine.routes.draw do
  
  namespace :admin do
    resources :users, only: [:index, :show]
    resources  :conversations, only: [:index, :show]
  end

end
