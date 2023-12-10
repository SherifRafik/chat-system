# frozen_string_literal: true

# == Schema Information
#
# Table name: applications
#
#  id          :bigint           not null, primary key
#  chats_count :integer          default(0), not null
#  deleted_at  :datetime
#  name        :string(255)      not null
#  token       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_applications_on_deleted_at  (deleted_at)
#  index_applications_on_token       (token) UNIQUE
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

  describe 'callback' do
    describe 'set_deleted_at' do
      before { allow(Time).to receive(:current).and_return(Time.zone.parse('2023-12-10 11:00:00')) }

      it 'sets the deleted_at before destroying the application' do
        application.destroy
        expect(application.deleted_at).to eq(Time.current)
      end
    end
  end
end
