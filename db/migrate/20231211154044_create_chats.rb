# frozen_string_literal: true

class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer :number, null: false
      t.integer :messages_count, default: 0, null: false
      t.references :application, null: false, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :chats, %i[number application_id], unique: true
  end
end
