# frozen_string_literal: true

# == Schema Information
#
# Table name: chats
#
#  id             :bigint           not null, primary key
#  messages_count :integer          default(0), not null
#  number         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  application_id :bigint           not null
#
# Indexes
#
#  index_chats_on_application_id             (application_id)
#  index_chats_on_number_and_application_id  (number,application_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (application_id => applications.id) ON DELETE => cascade
#

class Chat < ApplicationRecord
  # Validations
  validates :number, presence: true, uniqueness: { scope: :application_id }
  validates :messages_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Associations
  belongs_to :application
  has_many :messages

  # Delegation
  delegate :token, to: :application, prefix: true
end
