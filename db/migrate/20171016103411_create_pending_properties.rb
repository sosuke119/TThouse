class CreatePendingProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :pending_properties do |t|
      t.string "address"
      t.string "title"
      t.string "property_type"
      t.string "status"
      t.string "city"
      t.string "area"
      t.string "company"
      t.string "building_type"
      t.string "sales_status"
      t.string "floor_status"
      t.string "address_detail"
      t.string "state"
      t.string "road"
      t.integer "zip"
      t.integer "size_min"
      t.integer "garage"
      t.integer "garage_price"
      t.integer "price_min"
      t.integer "price_max"
      t.integer "sid"
      t.integer "sec_price"
      t.integer "price"
      t.integer "sec_max", default: 0
      t.integer "sec_min", default: 0
      t.decimal "lat", precision: 15, scale: 10
      t.decimal "long", precision: 15, scale: 10
      t.text "images_path", limit: 16777215
      t.text "modify_time", limit: 16777215
      
      t.timestamps
    end
  end
end
