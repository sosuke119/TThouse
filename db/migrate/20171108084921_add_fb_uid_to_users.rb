class AddFbUidToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :fb_uid, :integer
  end
end
