# frozen_string_literal: true

class ChatCreatorJob
  include Sidekiq::Job

  def perform(application_token, number)
    ActiveRecord::Base.transaction do
      application = Application.lock.find_by(token: application_token)

      if application.present?
        Chat.create(application: application, number: number)
        updated_chats_count = application.chats_count + 1
        application.update(chats_count: updated_chats_count)
      end
    end
  end
end
