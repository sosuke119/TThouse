class AddTriggerToSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :sessions, :trigger_id, :integer
    add_column :sessions, :trigger_type, :string
  end
end
