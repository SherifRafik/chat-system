# frozen_string_literal: true

require 'rails_helper'

module Applications
  RSpec.describe ApplicationCreator do
    describe '#call' do
      let(:creator) { described_class.new(params: params) }

      context 'with valid parameters' do
        let(:params) { { name: Faker::Company.name } }

        before do
          allow(InMemoryDataStore).to receive(:hset)
        end

        it 'returns true' do
          expect(creator.call).to be_truthy
        end

        it 'creates a new application' do
          expect { creator.call }.to change(Application, :count).by(1)
        end

        it 'saves the application to the in memory data store' do
          creator.call
          application = creator.application
          expect(InMemoryDataStore).to have_received(:hset).with(
            APPLICATION_HASH_KEY,
            application.token,
            application.chats_count
          ).once
        end
      end

      context 'with invalid parameters' do
        let(:params) { { name: '' } }

        it 'returns false' do
          expect(creator.call).to be_falsy
        end
      end
    end
  end
end
