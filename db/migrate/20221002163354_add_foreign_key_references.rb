class AddForeignKeyReferences < ActiveRecord::Migration[5.2]
  def change
    # add_foreign_key :chats, :applications, on_delete: :cascade ,column: :application_id
    # add_foreign_key :messages, :chats, on_delete: :cascade
    #
    add_reference :chats, :applications, index: true, foreign_key: true
    add_reference :messages, :chats, index: true, foreign_key: true

    add_index :applications, :token, unique: true
  end
end
