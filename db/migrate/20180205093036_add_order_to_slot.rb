class AddOrderToSlot < ActiveRecord::Migration[5.1]
  def change
    remove_column :sessions, :filling_session_slot_id, :integer
    add_column :slots, :order, :integer, default: 0
  end
end
