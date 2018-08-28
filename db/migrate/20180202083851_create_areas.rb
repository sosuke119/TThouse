class CreateAreas < ActiveRecord::Migration[5.1]
  def change
    unless table_exists?(:areas)
      create_table :areas do |t|
        t.string :name
        t.references :city, foreign_key: true

        t.timestamps
      end
    end
  end
end
