# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :applications, param: :token do
        resources :chats, param: :number, except: [:update]
      end
    end
  end
end
