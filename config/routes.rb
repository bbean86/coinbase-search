Rails.application.routes.draw do
  mount OpenApi::Rswag::Ui::Engine => '/api-docs'
  mount OpenApi::Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :currencies, only: [:index]
    end
  end
end
