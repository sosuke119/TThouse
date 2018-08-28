class AddPayloadReferencesToReplies < ActiveRecord::Migration[5.1]
  def change
    remove_reference :replies, :intention, index: true, foreign_key: true
    add_column :replies, :trigger_id, :integer
    add_column :replies, :trigger_type, :string    
  end
end
