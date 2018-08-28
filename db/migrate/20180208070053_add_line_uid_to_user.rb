class AddLineUidToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :line_uid, :string
  end
end
