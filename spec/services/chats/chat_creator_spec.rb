# frozen_string_literal: true

require 'rails_helper'

module Chats
  RSpec.describe ChatCreator do
    describe '#call' do
      let(:application) { create(:application) }
      let(:creator) { described_class.new(application_token: application.token) }

      context 'when application exists in memory' do
        before do
          allow(ChatCreatorJob).to receive(:perform_async)
        end

        it 'calls the chat creator job' do
          creator.call
          expect(ChatCreatorJob).to have_received(:perform_async).once
        end
      end

      context 'when application doesnt exist in memory' do
        context 'when application exists in the database' do
          before do
            allow(InMemoryDataStore).to receive(:hget).with(APPLICATION_HASH_KEY, application.token).and_return(nil)
            allow(InMemoryDataStore).to receive(:hset)
            allow(ChatCreatorJob).to receive(:perform_async)
          end

          it 'persists the application in memory' do
            creator.call
            expect(InMemoryDataStore).to have_received(:hset).with(APPLICATION_HASH_KEY, application.token, application.chats_count).once
          end

          it 'calls the chat creator job' do
            creator.call
            expect(ChatCreatorJob).to have_received(:perform_async).once
          end
        end

        context 'when application doesnt exist in database' do
          before { application.destroy }

          it 'returns false' do
            expect(creator.call).to be_falsy
          end
        end
      end
    end
  end
end
