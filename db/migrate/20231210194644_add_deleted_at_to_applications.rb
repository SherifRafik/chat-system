# frozen_string_literal: true

class AddDeletedAtToApplications < ActiveRecord::Migration[7.1]
  def change
    change_table :applications, bulk: true do |t|
      t.datetime :deleted_at, index: true
    end
  end
end
