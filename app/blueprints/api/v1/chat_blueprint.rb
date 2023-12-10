# frozen_string_literal: true

module Api
  module V1
    class ChatBlueprint < Blueprinter::Base
      identifier :number
      fields :application_token, :messages_count, :created_at, :updated_at
    end
  end
end
