# frozen_string_literal: true

module Chats
  class ChatDestroyer
    def initialize(application_token:, number:)
      @application_token = application_token
      @number = number
    end

    def call
      if InMemoryDataStore.hget(CHAT_HASH_KEY, generate_chat_key).present?
        ChatDestroyerJob.perform_async(application_token, number)
        true
      else
        false
      end
    end

    private

    attr_reader :application_token, :number

    def generate_chat_key
      KeyGenerator.generate_chat_key(application_token: application_token, number: number)
    end
  end
end
