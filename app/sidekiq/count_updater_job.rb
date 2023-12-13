# frozen_string_literal: true

require 'sidekiq-scheduler'

class CountUpdaterJob
  include Sidekiq::Job

  def perform
    p 'Hello from the count updater job'
  end
end
