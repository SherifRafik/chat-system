# frozen_string_literal: true

class ChatDestroyerJob
  include Sidekiq::Job

  def perform(application_id, number)
    ActiveRecord::Base.transaction do
      @application = Application.find(application_id)
      if application.present?
        @chat = application.chats.find_by(number: number)
        if chat.present?
          delete_chat_from_memory_datastore
          delete_messages_from_memory_datastore
          chat.destroy
        elsif chat_exists_in_memory?
          ChatDestroyerJob.perform_async(application_id, number)
        end
      end
    end
  end

  private

  attr_reader :application, :chat

  def delete_chat_from_memory_datastore
    InMemoryDataStore.hdel(CHAT_HASH_KEY, generate_chat_key)
  end

  def generate_chat_key
    KeyGenerator.generate_chat_key(application_token: application.token, number: chat.number)
  end

  def delete_messages_from_memory_datastore
    # TODO: Implement this when adding the messages
  end

  def chat_exists_in_memory?
    InMemoryDataStore.hget(CHAT_HASH_KEY, generate_chat_key).present?
  end
end
