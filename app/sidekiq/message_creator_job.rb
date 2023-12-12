# frozen_string_literal: true

class MessageCreatorJob
  include Sidekiq::Job

  def perform(application_token, chat_number, number, body)
    ActiveRecord::Base.transaction do
      application = Application.find_by(token: application_token)
      if application.present?
        @chat = Chat.lock.find_by(application_id: application.id, number: chat_number)

        if chat.present?
          Message.create(body: body, chat: chat, number: number)
          updated_messages_count = chat.messages_count + 1
          chat.update(messages_count: updated_messages_count)
        elsif chat_exists_in_memory?
          MessageCreatorJob.perform_in(30.seconds, application_token, chat_number, number, body)
        end
      end
    end
  end

  private

  attr_reader :chat

  def chat_exists_in_memory?
    InMemoryDataStore.hget(CHAT_HASH_KEY, chat.key).present?
  end
end
