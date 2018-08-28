class AddUrlToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :url, :string
  end
end
