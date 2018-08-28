class AddAditionAttributesToProperty < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :zip, :integer
    add_column :properties, :building_type, :string
    add_column :properties, :size_min, :integer
    add_column :properties, :garage, :integer
    add_column :properties, :garage_price, :integer
  end
end
