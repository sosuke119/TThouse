class RemovePriorityAtSlot < ActiveRecord::Migration[5.1]
  def change
    remove_column :slots, :order
  end
end
