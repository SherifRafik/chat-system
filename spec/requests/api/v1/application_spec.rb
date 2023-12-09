# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    RSpec.describe 'Applications' do
      describe 'GET #index' do
        let!(:applications) { create_list(:application, 2) }

        it 'returns a successful response' do
          get api_v1_applications_path
          expect(response).to have_http_status(:ok)
        end

        it 'returns all the applications' do
          get api_v1_applications_path
          response.parsed_body.each_with_index do |application, index|
            expect(application['token']).to eq(applications[index].token)
          end
        end
      end

      describe 'GET #show' do
        let(:application) { create(:application) }

        context 'when the token is valid' do
          before { get api_v1_application_path(application.token) }

          it 'returns a successful response' do
            expect(response).to have_http_status(:ok)
          end

          it 'returns the application' do
            expect(response.parsed_body['token']).to eq(application.token)
          end
        end

        context 'when the token is not valid' do
          before { get api_v1_application_path(SecureRandom.hex(16)) }

          it 'returns not_found status' do
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      describe 'POST #create' do
        let(:valid_params) { { application: { name: Faker::Company.name } } }

        context 'with valid parameters' do
          it 'returns created response' do
            post api_v1_applications_path, params: valid_params
            expect(response).to have_http_status(:created)
          end

          it 'creates a new application' do
            expect do
              post api_v1_applications_path, params: valid_params
            end.to change(Application, :count).by(1)
          end
        end

        context 'with invalid parameters' do
          it 'returns unprocessable entity status' do
            post api_v1_applications_path, params: { application: { name: '' } }
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      describe 'PUT #update' do
        let(:application) { create(:application) }

        context 'with valid parameters' do
          let(:valid_params) { { application: { name: Faker::Company.name } } }

          before { put api_v1_application_path(application.token), params: valid_params }

          it 'returns a successful response' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the application' do
            expect(application.reload.name).to eq(valid_params[:application][:name])
          end
        end

        context 'with invalid parameters' do
          it 'returns unprocessable entity status' do
            put api_v1_application_path(application.token), params: { application: { name: '' } }
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      describe 'DELETE #destroy' do
        let(:application) { create(:application) }

        before { delete api_v1_application_path(application.token) }

        it 'returns a successful response' do
          expect(response).to have_http_status(:no_content)
        end

        it 'destroys the application' do
          expect { application.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
