class CreateMessageAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :message_attachments do |t|
      t.references :message_log, foreign_key: true
      t.string :attachment_type
      t.string :url
      t.decimal :lat
      t.decimal :long

      t.timestamps
    end
  end
end
