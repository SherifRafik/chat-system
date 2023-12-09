# frozen_string_literal: true

module Tokenable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_token, if: ->(tokenable) { tokenable.token.blank? }
  end

  private

  def generate_token
    token = SecureRandom.hex(24)

    token = SecureRandom.hex(24) while InMemoryDataStore.hget(APPLICATION_HASH_KEY, token).present?

    self.token = token
  end
end
