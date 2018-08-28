class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.references :property, foreign_key: true
      t.datetime :started_at
      t.datetime :expired_at

      t.timestamps
    end
  end
end
