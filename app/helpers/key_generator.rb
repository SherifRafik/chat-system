# frozen_string_literal: true

class KeyGenerator
  def self.generate_chat_key(application_token:, number:)
    "#{application_token}_#{number}"
  end
end
