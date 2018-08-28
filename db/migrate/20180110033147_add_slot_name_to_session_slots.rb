class AddSlotNameToSessionSlots < ActiveRecord::Migration[5.1]
  def change
    add_column :session_slots, :name, :string
  end
end
