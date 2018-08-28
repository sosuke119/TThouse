class AddPlatformToMessageLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :message_logs, :platform, :string, default: 'facebook'

    
  end
end
