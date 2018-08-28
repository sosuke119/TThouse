class AddEchoAttachmentsToMessageLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :message_logs, :echo_attachments, :text
  end
end
