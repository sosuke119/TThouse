class RenameSessionSlotOrder < ActiveRecord::Migration[5.1]
  def change
    rename_column :session_slots, :order, :priority
  end
end
