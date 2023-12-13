# frozen_string_literal: true

module Api
  module V1
    class ChatsController < ApplicationController
      before_action :set_application, only: %i[index]
      before_action :set_chat, only: %i[show]

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
        destroyer = Chats::ChatDestroyer.new(application_token: params[:application_token],
                                             number: params[:number].to_i)
        if destroyer.call
          head :no_content
        else
          render json: { message: "Couldn't find a chat with number = #{params[:number]}" }, status: :not_found
        end
      end

      def search_messages
        application_token = params[:application_token]
        number = params[:chat_number]
        searcher = Chats::MessageSearcher.new(application_token: application_token, number: number,
                                              search_query: search_params[:query])
        if searcher.call
          render json: messages_serializer(searcher.result)
        else
          render json: { message: "Couldn't find a chat with number = #{number}" }, status: :not_found
        end
      end

      private

      attr_reader :application, :chat

      def set_chat
        @chat = Chat.find_by_key(chat_key)
      end

      def set_application
        @application = Application.find_by!(token: params[:application_token])
      end

      def chat_key
        KeyGenerator.generate_chat_key(application_token: params[:application_token], number: params[:number])
      end

      def chat_params
        params.require(:chat).permit
      end

      def search_params
        params.require(:chat).permit(:query)
      end

      def serialize(data)
        Api::V1::ChatBlueprint.render(data)
      end

      def messages_serializer(data)
        Api::V1::MessageBlueprint.render(data)
      end
    end
  end
end
