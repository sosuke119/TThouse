class AddParamsToPayloads < ActiveRecord::Migration[5.1]
  def change
    add_column :payloads, :params, :text
  end
end
