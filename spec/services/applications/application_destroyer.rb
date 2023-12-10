# frozen_string_literal: true

require 'rails_helper'

module Applications
  RSpec.describe ApplicationDestroyer do
    describe '#call' do
      let(:destroyer) { described_class.new(application: application) }

      context 'when application is valid' do
        let(:application) { create(:application) }

        before { allow(ApplicationDestroyerJob).to receive(:perform_async) }

        it 'returns true' do
          expect(destroyer.call).to be_truthy
        end

        it 'calls the application destroyer job' do
          destroyer.call
          expect(ApplicationDestroyerJob).to have_received(:perform_async).with(application.token).once
        end
      end

      context 'when application is invalid' do
        let(:application) { instance_double(Application, valid?: false) }

        it 'returns false' do
          expect(destroyer.call).to be_falsy
        end
      end
    end
  end
end
