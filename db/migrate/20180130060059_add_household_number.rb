class AddHouseholdNumber < ActiveRecord::Migration[5.1]
  def change
    unless column_exists?(:properties, :household_number, :integer )
      add_column :properties, :household_number, :integer
    end
  end
end
