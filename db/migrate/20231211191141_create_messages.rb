# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.integer :number, null: false
      t.text :body
      t.references :chat, null: false, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :messages, %i[number chat_id], unique: true
  end
end
