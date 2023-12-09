# frozen_string_literal: true

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

class Chat < ApplicationRecord
  # Validations
  validates :application_token, presence: true
  validates :number, presence: true, uniqueness: { scope: :application_token }
  validates :messages_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Associations
  belongs_to :application, foreign_key: 'application_token', primary_key: 'token', inverse_of: :chats
end
