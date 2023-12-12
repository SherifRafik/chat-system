# frozen_string_literal: true

module Messages
  class MessageCreator
    def initialize(params:, application_token:, chat_number:)
      @params = params
      @application_token = application_token
      @chat_number = chat_number
    end

    def call
      if InMemoryDataStore.hget(CHAT_HASH_KEY, generate_chat_key).present?
        create_message
      else
        false
      end
    end

    private

    attr_reader :chat_number, :application_token, :params

    def generate_chat_key
      KeyGenerator.generate_chat_key(application_token: application_token, number: chat_number)
    end

    def create_message
      number = InMemoryDataStore.hincrby(CHAT_HASH_KEY, generate_chat_key)
      MessageCreatorJob.perform_async(application_token, chat_number, number, params[:body])
      number
    end
  end
end
