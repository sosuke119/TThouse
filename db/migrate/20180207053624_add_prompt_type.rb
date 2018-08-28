class AddPromptType < ActiveRecord::Migration[5.1]
  def change
    add_column :slot_prompts, :category, :string, default: 'required'
  end
end
