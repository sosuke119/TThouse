class AddAttrToMessageLog < ActiveRecord::Migration[5.1]
  def change
    add_column :message_logs ,:seq, :integer
    add_column :message_logs ,:timestamp, :integer
    add_column :message_logs ,:mid, :string
     
    
  end
end
