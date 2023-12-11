# frozen_string_literal: true

module Chats
  class ChatDestroyer
    def initialize(chat:)
      @chat = chat
    end

    def call
      if chat.valid?
        ChatDestroyerJob.perform_async(application.id, chat.number)
      else
        false
      end
    end

    private

    attr_reader :chat

    def application
      chat.application
    end
  end
end
