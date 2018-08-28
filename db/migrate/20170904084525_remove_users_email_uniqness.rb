class RemoveUsersEmailUniqness < ActiveRecord::Migration[5.1]
  def change
    # remove_index :users, :email
    # add_index :users, :sender_id, unique: true

  end

end
