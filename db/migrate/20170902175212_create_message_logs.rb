class CreateMessageLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :message_logs do |t|
      t.references :user, foreign_key: true
      t.string :intention
      t.text :text
      t.string :entities
      t.string :message_type

      t.timestamps
    end
  end
end
