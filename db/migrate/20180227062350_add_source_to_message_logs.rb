class AddSourceToMessageLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :message_logs, :source, :string
    add_column :sessions, :conversation_started_at, :datetime
    add_column :sessions, :conversation_with_user_id, :integer

  end
end
