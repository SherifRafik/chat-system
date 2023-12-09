# frozen_string_literal: true

# == Schema Information
#
# Table name: applications
#
#  id          :bigint           not null, primary key
#  chats_count :integer          default(0), not null
#  name        :string(255)      not null
#  token       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_applications_on_token  (token) UNIQUE
#

class Application < ApplicationRecord
  include Tokenable

  # Validations
  validates :name, presence: true
  validates :token, presence: true, uniqueness: { case_sensitive: true }
  validates :chats_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
