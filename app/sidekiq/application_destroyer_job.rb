# frozen_string_literal: true

class ApplicationDestroyerJob
  include Sidekiq::Job

  def perform(application_token)
    ActiveRecord::Base.transaction do
      @application = Application.find_by(token: application_token)
      if application.present?
        delete_application_from_memory_datastore
        delete_chats_from_memory_datastore
        application.destroy
      end
    end
  end

  private

  attr_reader :application

  def delete_application_from_memory_datastore
    # Delete the token from redis (To prevent the chat creator job from queueinq)
    InMemoryDataStore.hdel(APPLICATION_HASH_KEY, application.token)
  end

  def delete_chats_from_memory_datastore
    # Delete the chats from redis (to prevent the message creator job from queuing)
    chats = application.chats
    chats.each do |chat|
      InMemoryDataStore.hdel(CHAT_HASH_KEY, chat.key)
    end
  end
end
