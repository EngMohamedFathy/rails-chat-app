class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :token, :limit=>100, :null=>false
      t.string :name, :limit=>150, :null=>false
      t.integer :chats_count, :default=>0

      t.timestamps
    end
  end
end
