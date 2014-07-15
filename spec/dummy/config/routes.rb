Rails.application.routes.draw do

  devise_for :users
  mount Tincanz::Engine => "/tincanz"
end
