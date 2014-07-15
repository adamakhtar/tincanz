Rails.application.routes.draw do

  root to: 'home#index'
  devise_for :users
  get '/users/sign_in', :to => "devise/sessions#new", :as => "sign_in"
  mount Tincanz::Engine => "/tincanz"

end
