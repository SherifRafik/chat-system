# frozen_string_literal: true

module Messages
  class MessageUpdater
    def initialize(params:, application_token:, chat_number:, number:)
      @params = params
      @application_token = application_token
      @chat_number = chat_number
      @number = number
    end

    def call
      if chat_exists_in_memory? && message_count_in_memory.to_i >= number
        MessageUpdaterJob.perform_async(application_token, chat_number, number, params[:body])
      else
        false
      end
    end

    private

    attr_reader :application_token, :chat_number, :number, :params

    def message_count_in_memory
      InMemoryDataStore.hget(CHAT_HASH_KEY, generate_chat_key)
    end

    def chat_exists_in_memory?
      message_count_in_memory.present?
    end

    def generate_chat_key
      KeyGenerator.generate_chat_key(application_token: application_token, number: chat_number)
    end
  end
end
