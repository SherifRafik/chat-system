# frozen_string_literal: true

class ChatDestroyerJob
  include Sidekiq::Job

  def perform(application_token, number)
    ActiveRecord::Base.transaction do
      @application = Application.find_by(token: application_token)
      if application.present?
        @chat = application.chats.find_by(number: number)
        if chat.present?
          delete_chat_from_memory_datastore(application_token, number)
          delete_messages_from_memory_datastore
          chat.destroy
        elsif chat_exists_in_memory?(application_token, number)
          ChatDestroyerJob.perform_in(30.seconds, application_token, number)
        end
      end
    end
  end

  private

  attr_reader :application, :chat

  def delete_chat_from_memory_datastore(application_token, number)
    InMemoryDataStore.hdel(CHAT_HASH_KEY, generate_chat_key(application_token, number))
  end

  def generate_chat_key(application_token, number)
    KeyGenerator.generate_chat_key(application_token: application_token, number: number)
  end

  def delete_messages_from_memory_datastore
    # TODO: Implement this when adding the messages
  end

  def chat_exists_in_memory?(application_token, number)
    InMemoryDataStore.hget(CHAT_HASH_KEY, generate_chat_key(application_token, number)).present?
  end
end
