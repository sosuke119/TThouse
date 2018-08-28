class ChangeEntityToJson < ActiveRecord::Migration[5.1]
  def change
    remove_column :message_logs, :entities
    add_column :message_logs, :entities, :text
  end
end
