class AddPayloadNameAndIdToMessageLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :message_logs, :payload_name, :string
    add_column :message_logs, :payload_id, :integer
  end
end
