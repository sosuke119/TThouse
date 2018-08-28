class AddIsHintToSlots < ActiveRecord::Migration[5.1]
  def change
    add_column :slots, :is_hint, :boolean, default: false
  end
end
