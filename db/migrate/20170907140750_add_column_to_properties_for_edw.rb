class AddColumnToPropertiesForEdw < ActiveRecord::Migration[5.1]
  def change
    add_column :properties , :sid , :integer
    add_column :properties , :company , :string
    add_column :properties , :sec_price , :integer
    add_column :properties , :images_path , :text
    add_column :properties , :modify_time , :text
  end
end
