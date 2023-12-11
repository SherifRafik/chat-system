# frozen_string_literal: true

class MessageCreatorJob
  include Sidekiq::Job

  def perform(application_token, chat_number, number, body)
    ActiveRecord::Base.transaction do
      application = Application.find_by(token: application_token)
      chat = Chat.lock.find_by(application_id: application.id, number: chat_number)

      if chat.present?
        Message.create(body: body, chat: chat, number: number)
        updated_messages_count = chat.messages_count + 1
        chat.update(messages_count: updated_messages_count)
      elsif chat_exists_in_memory?(application_token, chat_number)
        MessageCreatorJob.perform_in(30.seconds, application_token, chat_number, number, body)
      end
    end
  end

  private

  def chat_exists_in_memory?(application_token, chat_number)
    InMemoryDataStore.hget(CHAT_HASH_KEY, generate_chat_key(application_token, chat_number)).present?
  end

  def generate_chat_key(application_token, chat_number)
    KeyGenerator.generate_chat_key(application_token: application_token, number: chat_number)
  end
end
