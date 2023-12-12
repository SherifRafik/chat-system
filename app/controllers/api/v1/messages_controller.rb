# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_chat, only: %i[index show]
      before_action :set_message, only: %i[show]

      def index
        messages = chat.messages
        render json: serialize(messages)
      end

      def show
        render json: serialize(message)
      end

      def create
        application_token = params[:application_token]
        chat_number = params[:chat_number]
        creator = Messages::MessageCreator.new(params: message_params, application_token: application_token,
                                               chat_number: chat_number)
        message_number = creator.call

        if message_number.present?
          render json: { number: message_number }, status: :created
        else
          render json: { message: "Couldn't find a chat with number = #{chat_number}" }, status: :not_found
        end
      end

      def update
        application_token = params[:application_token]
        chat_number = params[:chat_number].to_i
        number = params[:number].to_i

        updater = Messages::MessageUpdater.new(params: message_params, application_token: application_token,
                                               chat_number: chat_number, number: number)

        if updater.call
          render json: { number: params[:number].to_i, body: message_params[:body] }, status: :created
        else
          render json: { message: "Couldn't find a message with number = #{params[:number]}" }, status: :not_found
        end
      end

      def destroy
        application_token = params[:application_token]
        chat_number = params[:chat_number].to_i
        number = params[:number].to_i

        destroyer = Messages::MessageDestroyer.new(application_token: application_token,
                                                   chat_number: chat_number, number: number)

        if destroyer.call
          head :no_content
        else
          render json: { message: "Couldn't find a message with number = #{params[:number]}" }, status: :not_found
        end
      end

      private

      attr_reader :message, :chat, :application

      def set_message
        @message = chat.messages.find_by!(number: params[:number])
      end

      def set_chat
        application = Application.find_by!(token: params[:application_token])
        @chat = application.chats.find_by!(number: params[:chat_number])
      end

      def serialize(data)
        Api::V1::MessageBlueprint.render(data)
      end

      def message_params
        params.require(:message).permit(:body)
      end
    end
  end
end
