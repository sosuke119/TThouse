class AddPromptOptionsToSessionSlots < ActiveRecord::Migration[5.1]
  def change
    add_column :session_slots, :prompt_options, :string
  end
end
