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

FactoryBot.define do
  factory :application do
    name { Faker::Company.name }
    token { SecureRandom.hex(24) }
    chats_count { 0 }
  end
end
