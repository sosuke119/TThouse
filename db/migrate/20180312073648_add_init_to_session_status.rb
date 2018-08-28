class AddInitToSessionStatus < ActiveRecord::Migration[5.0]
  def change
    change_column :sessions, :status, :string, default: 'bot'

    Session.update_all(status: 'done')
  end
end
