# frozen_string_literal: true

module Applications
  class ApplicationDestroyer
    def initialize(application:)
      @application = application
    end

    def call
      if application.valid?
        application.update(deleted_at: Time.current)
        ApplicationDestroyerJob.perform_async(application.token)
        true
      else
        false
      end
    end

    private

    attr_reader :application
  end
end
