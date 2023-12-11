# frozen_string_literal: true

module Chats
  class ChatDestroyer
    def initialize(application_token:, number:)
      @application_token = application_token
      @number = number
    end

    def call
      ChatDestroyerJob.perform_async(application_token, number)
    end

    private

    attr_reader :application_token, :number
  end
end
