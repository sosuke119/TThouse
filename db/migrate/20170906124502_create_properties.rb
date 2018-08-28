class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    drop_table :properties, if_exists: true
    
    create_table :properties do |t|
      t.string :address
      t.string :title
      t.string :property_type
      t.string :status
      t.string :city
      t.string :area
      t.integer :price
      t.decimal :lat, precision: 15, scale: 10
      t.decimal :long, precision: 15, scale: 10

      t.timestamps
    end
  end
end
