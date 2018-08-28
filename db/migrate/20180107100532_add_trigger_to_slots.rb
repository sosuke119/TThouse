class AddTriggerToSlots < ActiveRecord::Migration[5.1]
  def change
    add_column :slots, :trigger_id, :integer
    add_column :slots, :trigger_type, :string
  end
end
