# frozen_string_literal: true

require 'sidekiq/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :applications, param: :token do
        resources :chats, param: :number, except: [:update] do
          get 'messages/search', to: 'chats#search_messages'
          resources :messages, param: :number
        end
      end
    end
  end
end
