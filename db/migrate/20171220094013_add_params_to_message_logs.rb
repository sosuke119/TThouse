class AddParamsToMessageLogs < ActiveRecord::Migration[5.1]
  def change
    remove_column :payloads, :params, :text
    add_column :message_logs, :payload_param, :text
  end
end
