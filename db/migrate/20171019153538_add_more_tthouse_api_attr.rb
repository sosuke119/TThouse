class AddMoreTthouseApiAttr < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :room, :string
    add_column :pending_properties, :room, :string
    
  end
end
