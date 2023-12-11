# frozen_string_literal: true

module Api
  module V1
    class ChatsController < ApplicationController
      before_action :set_application, only: %i[index show destroy]
      before_action :set_chat, only: %i[show destroy]

      def index
        chats = application.chats
        render json: serialize(chats)
      end

      def show
        render json: serialize(chat)
      end

      def create
        application_token = params[:application_token]
        creator = Chats::ChatCreator.new(application_token: application_token)
        chat_number = creator.call

        if chat_number.present?
          render json: { number: chat_number }, status: :created
        else
          render json: { message: "Couldn't find an application with token = #{application_token}" }, status: :not_found
        end
      end

      def destroy
        chat.destroy
        head :no_content
      end

      private

      attr_reader :application, :chat

      def set_chat
        @chat = application.chats.find_by!(number: params[:number])
      end

      def set_application
        @application = Application.find_by!(token: params[:application_token])
      end

      def chat_params
        params.require(:chat).permit
      end

      def serialize(data)
        Api::V1::ChatBlueprint.render(data)
      end
    end
  end
end
