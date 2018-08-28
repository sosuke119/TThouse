class CreateRoads < ActiveRecord::Migration[5.1]
  def change
    unless table_exists?(:roads)
      create_table :roads do |t|
        t.string :name
        t.references :area, foreign_key: true

        t.timestamps
      end
    end
  end
end
