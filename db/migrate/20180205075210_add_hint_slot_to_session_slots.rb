class AddHintSlotToSessionSlots < ActiveRecord::Migration[5.1]
  def change
    add_column :session_slots, :is_hint, :boolean, default: false
  end
end
