# frozen_string_literal: true

class MessageDestroyerJob
  include Sidekiq::Job

  def perform(application_token, chat_number, number)
    @application_token = application_token
    @chat_number = chat_number

    ActiveRecord::Base.transaction do
      application = Application.find_by(token: application_token)
      if application.present?
        chat = application.chats.find_by(number: chat_number)
        if chat.present?
          message = chat.messages.find_by(number: number)
          if message.present?
            message.destroy
          elsif chat_exists_in_memory? && message_count_in_memory.to_i >= number
            MessageDestroyerJob.perform_in(30.seconds, application_token, chat_number, number)
          end
        elsif chat_exists_in_memory?
          MessageDestroyerJob.perform_in(30.seconds, application_token, chat_number, number)
        end
      end
    end
  end

  private

  attr_reader :application_token, :chat_number

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
