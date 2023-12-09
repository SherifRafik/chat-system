# == Schema Information
#
# Table name: chats
#
#  id                :bigint           not null, primary key
#  application_token :string(255)      not null
#  messages_count    :integer          default(0), not null
#  number            :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  fk_rails_e72f51c06b                          (application_token)
#  index_chats_on_number_and_application_token  (number,application_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (application_token => applications.token) ON DELETE => cascade
#
require 'rails_helper'

RSpec.describe Chat do
  subject(:chat) { create(:chat) }

  describe 'factory' do
    it 'has a valid record' do
      expect(chat).to be_valid
    end
  end

  describe 'validations' do
    describe 'number' do
      it { is_expected.to validate_presence_of(:number) }
      it { is_expected.to validate_uniqueness_of(:number).scoped_to(:application_token) }
    end

    describe 'application_token' do
      it { is_expected.to validate_presence_of(:application_token) }
    end

    describe 'messages_count' do
      it { is_expected.to validate_numericality_of(:messages_count).is_greater_than_or_equal_to(0).only_integer }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:application) }
  end
end
