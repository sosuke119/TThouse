class AddSecPriceMaxAndMinToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :sec_max, :integer, default: 0
    add_column :properties, :sec_min, :integer, default: 0
  end
end
