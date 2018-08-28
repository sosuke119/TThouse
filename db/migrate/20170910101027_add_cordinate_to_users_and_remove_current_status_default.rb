class AddCordinateToUsersAndRemoveCurrentStatusDefault < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :long ,:decimal , precision:15 ,scale: 10
    add_column :users, :lat  ,:decimal , precision:15 ,scale: 10
    change_column :users, :current_status, :string, default:''
  end
end
