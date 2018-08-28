class ChangeRoomMinMaxToInteger < ActiveRecord::Migration[5.1]
  def change
    unless column_exists?(:properties, :room_min, :integer )
      remove_column :properties, :room_min
      remove_column :properties, :room_max
      add_column  :properties, :room_min, :integer
      add_column  :properties, :room_max, :integer
    end
  end
end
