# frozen_string_literal: true

module SoftDeletable
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted_at: nil) }

    scope :with_deleted, -> { unscope(where: :deleted_at) }

    scope :not_deleted, -> { where(deleted_at: nil) }

    before_destroy :set_deleted_at
  end

  def set_deleted_at
    self.deleted_at = Time.current
  end
end
