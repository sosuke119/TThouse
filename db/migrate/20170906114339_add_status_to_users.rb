class AddStatusToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :current_status, :string
    add_column :users, :last_status, :string
  end
end
