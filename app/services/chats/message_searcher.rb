# frozen_string_literal: true

module Chats
  class MessageSearcher
    attr_reader :result

    def initialize(application_token:, number:, search_query:)
      @application_token = application_token
      @number = number
      @search_query = search_query
    end

    def call
      if does_chat_exist_in_memory?
        @result = Message.search(search_query, generated_chat_key)
        true
      else
        false
      end
    end

    private

    attr_reader :application_token, :number, :search_query

    def generated_chat_key
      KeyGenerator.generate_chat_key(application_token: application_token, number: number)
    end

    def does_chat_exist_in_memory?
      InMemoryDataStore.hget(CHAT_HASH_KEY, generated_chat_key).present?
    end
  end
end
