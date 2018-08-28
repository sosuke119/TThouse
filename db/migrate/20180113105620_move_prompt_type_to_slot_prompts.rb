class MovePromptTypeToSlotPrompts < ActiveRecord::Migration[5.1]
  def change
    remove_column :slots,        :prompt_type , :string, default: 'text'
    add_column :slot_prompts, :prompt_type , :string, default: 'text'
  end
end
