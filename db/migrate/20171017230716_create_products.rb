class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.text :description
      t.string :photo_url
      t.integer :quantity
      t.boolean :visible
      t.integer :merchant_id

      t.timestamps
    end
  end
end
