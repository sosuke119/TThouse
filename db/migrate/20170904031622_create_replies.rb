class CreateReplies < ActiveRecord::Migration[5.1]
  def change
    create_table :replies do |t|
      t.references :intention, foreign_key: true
      t.text :text
      t.string :reply_type

      t.timestamps
    end
  end
end
