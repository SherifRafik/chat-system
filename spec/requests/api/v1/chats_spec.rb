# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    RSpec.describe 'Chats' do
      let(:application) { create(:application) }

      describe 'GET #index' do
        let(:chats) { create_list(:chats, 2, application: application) }

        it 'returns a successful response' do
          get api_v1_application_chats_path(application_token: application.token)
          expect(response).to have_http_status(:ok)
        end

        it 'returns all the chats' do
          get api_v1_application_chats_path(application_token: application.token)
          response.parsed_body.each_with_index do |chat, index|
            expect(chat['number']).to eq(chats[index].number)
          end
        end
      end

      describe 'GET #show' do
        let(:chat) { create(:chat, application: application) }

        context 'when the chat number is valid' do
          before { get api_v1_application_chat_path(application_token: application.token, number: chat.number) }

          it 'returns a successful response' do
            expect(response).to have_http_status(:ok)
          end

          it 'returns the application' do
            expect(response.parsed_body['number']).to eq(chat.number)
          end
        end

        context 'when the chat number is not valid' do
          before { get api_v1_application_chat_path(application_token: application.token, number: (Random.rand * 10).ceil) }

          it 'returns not_found status' do
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      describe 'POST #create' do
        let(:creator_double) { instance_double(Chats::ChatCreator, call: true) }

        before do
          allow(Chats::ChatCreator).to receive(:new).with(application_token: application.token).and_return(creator_double)
          post api_v1_application_chats_path(application_token: application.token)
        end

        it 'returns created response' do
          post api_v1_application_chats_path(application_token: application.token)
          expect(response).to have_http_status(:created)
        end

        it 'calls the creator service' do
          expect(creator_double).to have_received(:call)
        end
      end
    end
  end
end