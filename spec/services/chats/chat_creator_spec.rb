# frozen_string_literal: true

require 'rails_helper'

module Chats
  RSpec.describe ChatCreator do
    describe '#call' do
      let(:application) { create(:application) }
      let(:creator) { described_class.new(application_token: application.token) }

      context 'when application exists in memory' do
        before do
          allow(InMemoryDataStore).to receive(:hget).with(APPLICATION_HASH_KEY, application.token).and_return('1')
          allow(ChatCreatorJob).to receive(:perform_async)
        end

        it 'calls the chat creator job' do
          creator.call
          expect(ChatCreatorJob).to have_received(:perform_async).once
        end
      end

      context 'when application doesnt exist in memory' do
        before do
          allow(InMemoryDataStore).to receive(:hget).with(APPLICATION_HASH_KEY, application.token).and_return(nil)
        end

        it 'returns false' do
          expect(creator.call).to be_falsy
        end
      end
    end
  end
end
