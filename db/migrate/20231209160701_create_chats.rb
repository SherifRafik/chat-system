# frozen_string_literal: true

class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.string :application_token, null: false
      t.integer :number, null: false
      t.integer :messages_count, default: 0, null: false

      t.timestamps
    end

    add_foreign_key :chats, :applications, column: :application_token, primary_key: :token, on_delete: :cascade
    add_index :chats, %i[number application_token], unique: true
  end
end
