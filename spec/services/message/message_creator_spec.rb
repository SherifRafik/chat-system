# frozen_string_literal: true

require 'rails_helper'

module Messages
  RSpec.describe MessageCreator do
    describe '#call' do
      let(:params) { { body: Faker::Lorem.sentence } }
      let(:creator) { described_class.new(params: params, application_token: application.token, chat_number: chat.number) }
      let(:chat) { create(:chat) }
      let(:application) { chat.application }

      context 'when chat exists in memory' do
        before do
          allow(InMemoryDataStore).to receive(:hget).with(CHAT_HASH_KEY, "#{application.token}_#{chat.number}").and_return('1')
          allow(MessageCreatorJob).to receive(:perform_async)
        end

        it 'calls the chat creator job' do
          creator.call
          expect(MessageCreatorJob).to have_received(:perform_async).once
        end
      end

      context 'when chat doesnt exist in memory' do
        before do
          allow(InMemoryDataStore).to receive(:hget).with(CHAT_HASH_KEY, "#{application.token}_#{chat.number}").and_return(nil)
        end

        it 'returns false' do
          expect(creator.call).to be_falsy
        end
      end
    end
  end
end
