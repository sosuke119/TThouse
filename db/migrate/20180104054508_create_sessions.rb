class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.references :user, foreign_key: true
      t.string :state
      t.datetime :finished_at
      t.datetime :expired_at

      t.timestamps
    end
  end
end
