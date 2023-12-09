# frozen_string_literal: true

module Tokenable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_token, if: ->(tokenable) { tokenable.token.blank? }
  end

  private

  def generate_token
    token = SecureRandom.hex(16)

    while InMemoryDataStore.exists?(token)
      token = SecureRandom.hex(16)
    end

    self.token = token
  end
end
