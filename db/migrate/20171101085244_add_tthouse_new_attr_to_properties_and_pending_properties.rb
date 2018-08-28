class AddTthouseNewAttrToPropertiesAndPendingProperties < ActiveRecord::Migration[5.1]
  def change
    
    add_column :properties,:room_min, :string
    add_column :pending_properties,:room_min, :string

    
    add_column :properties,:room_max, :string
    add_column :pending_properties,:room_max, :string

    
    add_column :properties,:price_range, :string
    add_column :pending_properties,:price_range, :string

    
    add_column :properties,:public_rate, :string
    add_column :pending_properties,:public_rate, :string

  end
end
