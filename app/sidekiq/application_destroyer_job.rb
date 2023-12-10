# frozen_string_literal: true

class ApplicationDestroyerJob
  include Sidekiq::Job

  def perform(application_token)
    ActiveRecord::Base.transaction do
      application = Application.find_by(token: application_token)
      if application.present?
        application_token = application.token
        # Delete the token from redis (To prevent the chat creator job from queueinq)
        InMemoryDataStore.hdel(APPLICATION_HASH_KEY, application_token)
        # Delete the chats from redis (to prevent the message creator job from queuing)
        chats = application.chats

        chats.each do |chat|
          generated_chat_key = KeyGenerator.generate_chat_key(application_token: application_token, number: chat.number)
          InMemoryDataStore.hdel(CHAT_HASH_KEY, generated_chat_key)
        end
        # Destroy the application
        application.destroy
      end
    end
  end
end
