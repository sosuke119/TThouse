class CreateAdwords < ActiveRecord::Migration[5.1]
  def change
    create_table :adwords do |t|
      t.references :campaign, foreign_key: true
      t.string :text
      t.string :category

      t.timestamps
    end
  end
end
