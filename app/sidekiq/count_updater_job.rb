# frozen_string_literal: true

require 'sidekiq-scheduler'

class CountUpdaterJob
  include Sidekiq::Job

  def perform
    application_tokens = InMemoryDataStore.hgetall(APPLICATION_HASH_KEY).keys
    chat_keys = InMemoryDataStore.hgetall(CHAT_HASH_KEY).keys

    ActiveRecord::Base.transaction do
      # Update applications chat count
      applications = Application.where(token: application_tokens)
      applications.each do |application|
        application.chats_count = InMemoryDataStore.hget(APPLICATION_HASH_KEY, application.token).to_i
      end
      applications.each(&:save)

      # Update chats messages count
      chats = Chat.find_by_keys(chat_keys)
      chats.each do |chat|
        chat.messages_count = InMemoryDataStore.hget(CHAT_HASH_KEY, chat.key).to_i
      end
      chats.each(&:save)
    end
  end
end
