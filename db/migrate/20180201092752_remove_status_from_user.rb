class RemoveStatusFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :current_status
    remove_column :users, :last_status
  end
end
