class FixReferences < ActiveRecord::Migration[5.1]
  def change
    remove_reference    :message_logs, :sessions, index: true
    add_reference :message_logs, :session, index: true
  end
end
