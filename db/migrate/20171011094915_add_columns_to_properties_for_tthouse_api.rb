class AddColumnsToPropertiesForTthouseApi < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :road, :string
    add_column :properties, :price_min, :integer
    add_column :properties, :price_max, :integer
    add_column :properties, :sales_status, :string
    add_column :properties, :floor_status, :string
    add_column :properties, :address_detail, :string

  end
end
