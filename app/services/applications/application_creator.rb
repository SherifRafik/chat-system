# frozen_string_literal: true

module Applications
  class ApplicationCreator
    attr_reader :application

    def initialize(params:)
      @application = Application.new(params)
    end

    def call
      if application.save
        InMemoryDataStore.set(application.token, application.chats_count)
        true
      else
        false
      end
    end
  end
end
