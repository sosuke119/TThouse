class CreatePayloads < ActiveRecord::Migration[5.1]
  def change
    create_table :payloads do |t|
      t.string :name

      t.timestamps
    end
  end
end
