# frozen_string_literal: true

class ChatDestroyerJob
  include Sidekiq::Job

  def perform(application_token, number)
    @application_token = application_token
    @number = number

    ActiveRecord::Base.transaction do
      @application = Application.lock.find_by(token: application_token)
      if application.present?
        chat = application.chats.find_by(number: number)
        if chat.present?
          delete_chat_from_memory_datastore
          chat.destroy
          decrement_chats_count_in_memory
          decrement_chats_count_in_application
        elsif chat_exists_in_memory?
          ChatDestroyerJob.perform_in(30.seconds, application_token, number)
        end
      end
    end
  end

  private

  attr_reader :application, :application_token, :number

  def delete_chat_from_memory_datastore
    InMemoryDataStore.hdel(CHAT_HASH_KEY, generate_chat_key)
  end

  def generate_chat_key
    KeyGenerator.generate_chat_key(application_token: application_token, number: number)
  end

  def chat_exists_in_memory?
    InMemoryDataStore.hget(CHAT_HASH_KEY, generate_chat_key).present?
  end

  def decrement_chats_count_in_application
    updated_chats_count = InMemoryDataStore.hget(APPLICATION_HASH_KEY, application.token)
    application.update(chats_count: updated_chats_count)
  end

  def decrement_chats_count_in_memory
    InMemoryDataStore.hincrby(APPLICATION_HASH_KEY, application.token, -1)
  end
end
