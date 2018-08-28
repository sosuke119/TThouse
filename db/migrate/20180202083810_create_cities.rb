class CreateCities < ActiveRecord::Migration[5.1]
  def change
    unless table_exists?(:cities)
      create_table :cities do |t|
        t.string :name

        t.timestamps
      end
    end
  end
end
