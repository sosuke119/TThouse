class AddRequiredToSessionSlot < ActiveRecord::Migration[5.1]
  def change
    add_column :session_slots, :required, :boolean
    add_column :session_slots, :order, :integer
  end
end
