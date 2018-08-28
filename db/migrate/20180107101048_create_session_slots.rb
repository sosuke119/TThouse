class CreateSessionSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :session_slots do |t|
      t.references :session, foreign_key: true
      t.references :slot, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
