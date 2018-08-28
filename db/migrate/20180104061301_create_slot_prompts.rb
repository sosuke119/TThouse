class CreateSlotPrompts < ActiveRecord::Migration[5.1]
  def change
    create_table :slot_prompts do |t|
      t.references :slot, foreign_key: true
      t.string :text

      t.timestamps
    end
  end
end
