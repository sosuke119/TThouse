class FixPropertyCloumns < ActiveRecord::Migration[5.1]
  def change
    unless column_exists?(:properties, :public_ratio_min, :float )
      add_column :properties , :public_ratio_min, :integer
      add_column :properties , :public_ratio_max, :integer
      add_column :properties, :click_count, :integer
    end
    drop_table :pending_properties
  end
end
