Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # githubからのリダイレクトを受け取るためのルーティング
  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/update', to: 'sessions#update'
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          get :home
        end
      end
    end
  end
end
