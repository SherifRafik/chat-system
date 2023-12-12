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
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # Validations
  validates :number, presence: true, uniqueness: { scope: :chat_id }

  # Associations
  belongs_to :chat

  # Delegations
  delegate :application_token, to: :chat
  delegate :number, to: :chat, prefix: true
  delegate :key, to: :chat, prefix: true

  settings do
    mapping dynamic: false do
      indexes :chat_key, type: :text, analyzer: 'english'
      indexes :body, type: :text, analyzer: 'english'
    end
  end

  # Choose the fields included in the object that is sent to ES
  def as_indexed_json(_options = nil)
    as_json(only: %i[body], methods: :chat_key)
  end

  def self.search(query, chat_key)
    __elasticsearch__.search(
      {
        query: {
          bool: {
            must: [
              {
                wildcard: { body: "*#{query}*" }
              }
            ],
            filter: [
              { term: { chat_key: chat_key } }
            ]
          }
        }
      }
    ).records.to_a
  end
end
