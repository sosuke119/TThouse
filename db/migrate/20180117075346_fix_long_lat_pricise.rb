class FixLongLatPricise < ActiveRecord::Migration[5.1]
  def change
    change_column :message_attachments, :lat, :decimal, precision: 20, scale: 15
    change_column :message_attachments, :long, :decimal, precision: 20, scale: 15
    change_column :properties, :lat, :decimal, precision: 20, scale: 15
    change_column :properties, :long, :decimal, precision: 20, scale: 15
    change_column :users, :lat, :decimal, precision: 20, scale: 15
    change_column :users, :long, :decimal, precision: 20, scale: 15
  end
end
