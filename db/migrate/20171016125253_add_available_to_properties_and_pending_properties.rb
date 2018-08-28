class AddAvailableToPropertiesAndPendingProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :available, :boolean, default: true
    add_column :pending_properties, :available, :boolean, default: true
  end
end
