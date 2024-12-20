Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope 'api' do
    namespace :jira do
      resources :issues, only: [:create]
    end
  end
end
