class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    unless table_exists?(:companies)
      create_table :companies do |t|
        t.string :name

        t.timestamps
      end
    end
  end
end
