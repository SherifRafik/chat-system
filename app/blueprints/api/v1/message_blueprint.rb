# frozen_string_literal: true

module Api
  module V1
    class MessageBlueprint < Blueprinter::Base
      identifier :number
      fields :chat_number, :body, :created_at, :updated_at
    end
  end
end
