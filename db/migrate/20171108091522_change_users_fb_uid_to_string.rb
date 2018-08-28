class ChangeUsersFbUidToString < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :fb_uid, :integer
    add_column :users, :fb_uid, :string
  end
end
