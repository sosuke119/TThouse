class AddExpiredAtToSession < ActiveRecord::Migration[5.1]
  def change
    add_column  :sessions, :expired_at, :datetime
  end
end
