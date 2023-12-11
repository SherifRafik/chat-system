# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  body       :text(65535)
#  number     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :bigint           not null
#
# Indexes
#
#  index_messages_on_chat_id             (chat_id)
#  index_messages_on_number_and_chat_id  (number,chat_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id) ON DELETE => cascade
#
require 'rails_helper'

RSpec.describe Message do
  subject(:message) { create(:message) }

  describe 'factory' do
    it 'has a valid record' do
      expect(message).to be_valid
    end
  end

  describe 'validations' do
    describe 'number' do
      it { is_expected.to validate_presence_of(:number) }
      it { is_expected.to validate_uniqueness_of(:number).scoped_to(:chat_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:chat) }
  end
end
