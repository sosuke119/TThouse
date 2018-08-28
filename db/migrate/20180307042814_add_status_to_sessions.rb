class AddStatusToSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :sessions, :status, :string
  end
end
