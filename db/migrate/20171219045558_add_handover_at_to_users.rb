class AddHandoverAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :handed_over_at, :datetime
  end
end
