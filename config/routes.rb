Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # githubからのリダイレクトを受け取るためのルーティング
  get '/auth/:provider/callback', to: 'sessions#create'

  # Defines the root path route ("/")
  # root "articles#index"
end
