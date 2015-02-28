Rails.application.routes.draw do
  resources :movies
  get '/movies/:id/same_director', to: 'movies#same_director', as: 'same_director'
end
