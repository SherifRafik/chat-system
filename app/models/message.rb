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

class Message < ApplicationRecord
  # Validations
  validates :number, presence: true, uniqueness: { scope: :chat_id }

  # Associations
  belongs_to :chat

  # Delegations
  delegate :application_token, to: :chat
  delegate :number, to: :chat, prefix: true
end
