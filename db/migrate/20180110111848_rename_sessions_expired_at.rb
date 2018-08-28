class RenameSessionsExpiredAt < ActiveRecord::Migration[5.1]
  def change
    rename_column    :sessions, :expired_at, :last_messaged_at
    add_reference    :message_logs, :sessions, index: true
  end
end
