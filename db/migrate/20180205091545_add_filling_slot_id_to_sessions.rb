class AddFillingSlotIdToSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :sessions, :filling_session_slot_id, :integer
  end
end
