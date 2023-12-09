# frozen_string_literal: true

# == Schema Information
#
# Table name: applications
#
#  id          :bigint           not null, primary key
#  chats_count :integer          default(0), not null
#  name        :string(255)      not null
#  token       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_applications_on_token  (token) UNIQUE
#
require 'rails_helper'

RSpec.describe Application do
  subject(:application) { build(:application) }

  describe 'factory' do
    it 'has a valid record' do
      expect(application).to be_valid
    end
  end

  describe 'validations' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
    end

    describe 'token' do
      it { is_expected.to validate_uniqueness_of(:token) }
    end

    describe 'chats_count' do
      it { is_expected.to validate_numericality_of(:chats_count).is_greater_than_or_equal_to(0).only_integer }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:chats) }
  end
end
