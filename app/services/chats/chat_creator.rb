# frozen_string_literal: true

module Chats
  class ChatCreator
    def initialize(application_token:)
      @application_token = application_token
    end

    def call
      if application_exists_in_memory?
        create_chat
      else
        # Application is deleted
        false
      end
    end

    private

    attr_reader :application_token

    def application_exists_in_memory?
      InMemoryDataStore.hget(APPLICATION_HASH_KEY, application_token).present?
    end

    def generate_chat_key(number)
      KeyGenerator.generate_chat_key(application_token: application_token, number: number)
    end

    def persist_chat_in_memory(generated_chat_key)
      InMemoryDataStore.hset(CHAT_HASH_KEY, generated_chat_key, 0)
    end

    def create_chat
      number = InMemoryDataStore.hincrby(APPLICATION_HASH_KEY, application_token)
      generated_chat_key = generate_chat_key(number)
      persist_chat_in_memory(generated_chat_key)
      ChatCreatorJob.perform_async(application_token, number)
      number
    end
  end
end
