# frozen_string_literal: true

module Api
  module V1
    class ApplicationBlueprint < Blueprinter::Base
      identifier :token
      fields :name, :chats_count, :created_at, :updated_at
    end
  end
end
