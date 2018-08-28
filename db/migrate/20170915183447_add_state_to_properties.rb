class AddStateToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :state, :string
  end
end
