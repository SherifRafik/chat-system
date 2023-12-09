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

FactoryBot.define do
  factory :chat do
    application
    number { Faker::Number.unique.number(digits: 2) }
    messages_count { 0 }
  end
end
