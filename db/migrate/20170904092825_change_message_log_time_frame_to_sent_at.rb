class ChangeMessageLogTimeFrameToSentAt < ActiveRecord::Migration[5.1]
  def change
    change_column :message_logs, :timestamp, :datetime
    rename_column :message_logs, :timestamp, :sent_at
  end
end
