class AddRequiredAndPriorityToSlot < ActiveRecord::Migration[5.1]
  def change
    add_column :slots, :required, :boolean
    add_column :slots, :priority, :integer
  end
end
