class AddPromptTypeToSlots < ActiveRecord::Migration[5.1]
  def change
    add_column :slots, :prompt_type , :string, default: 'text'
  end
end
