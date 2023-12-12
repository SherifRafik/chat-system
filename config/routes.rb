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
          resources :messages, param: :number do
            get 'search', to: 'chats#search_messages', on: :collection
          end
        end
      end
    end
  end
end
