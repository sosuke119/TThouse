class AddPositionToAdwords < ActiveRecord::Migration[5.1]
  def change
    add_column :adwords, :position, :integer, default: 2
  end
end
