class AddUserSourceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :source, :string, default: 'facebook'
  end
end
