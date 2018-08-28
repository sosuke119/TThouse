class ChangeEntityToLuis < ActiveRecord::Migration[5.1]
  def change
    rename_column :message_logs, :entities, :luis
  end
end
