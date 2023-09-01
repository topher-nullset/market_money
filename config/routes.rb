Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v0 do
      get '/markets/search', to:'markets#search'
      resources :markets, only: [:index, :show, :create, :destroy] do
        resources :vendors, only: [:index]
        member do
          get :nearest_atms
        end
      end
      
      resources :vendors, only: [:show, :create, :update, :destroy]
      resources :market_vendors, only: [:create]
      delete '/market_vendors/', to: 'market_vendors#destroy'
    end
  end
end
