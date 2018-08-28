class ChangeSomeIntegerToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :properties, :public_ratio_min, :float
    change_column :properties, :public_ratio_max, :float
    change_column :properties, :price_min,        :float
    change_column :properties, :price_max,        :float
    change_column :properties, :sec_max,          :float
    change_column :properties, :sec_min,          :float
    change_column :properties, :size_min,         :float
    change_column :properties, :sec_price,        :float
    change_column :properties, :price,            :float
    change_column :properties, :garage_price,     :float
  end
end
