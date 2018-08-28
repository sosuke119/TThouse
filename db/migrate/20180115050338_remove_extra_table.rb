class RemoveExtraTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :intention_slots, if_exists: true
    drop_table :session_intentions, if_exists: true
    drop_table :session_payloads, if_exists: true
    drop_table :payload_slots, if_exists: true
  end
end
