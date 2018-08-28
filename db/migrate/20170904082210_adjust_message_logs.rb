class AdjustMessageLogs < ActiveRecord::Migration[5.1]
  def change
    rename_column :message_logs, :intention , :intention_name
    add_reference :message_logs, :intention, index: true
  end
end
