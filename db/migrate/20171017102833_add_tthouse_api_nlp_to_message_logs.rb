class AddTthouseApiNlpToMessageLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :message_logs, :tthouse_api_nlp, :text
  end
end
