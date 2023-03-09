Rails.application.routes.draw do
  get 'user/all'
  get 'user/:id', to: 'user#show'
  get 'user/:id/hit_endpoint(/:time_zone)', to: 'user#hit_endpoint'



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
