class AddIntentionScoreToIntentions < ActiveRecord::Migration[5.1]
  def change
    add_column :message_logs, :intention_score, :decimal, precision: 15, scale: 10
  end
end
