class FixSlotTypeToSlotsAndSessionSlots < ActiveRecord::Migration[5.1]
  def change
    remove_column :slots, :prompt_type , :string, default: 'text'
    remove_column :session_slots, :prompt_type , :string, default: 'text'
    add_column :slots, :slot_type , :string, default: 'text'
    add_column :session_slots, :slot_type , :string, default: 'text'
  end
end
