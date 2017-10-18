class AddMerchantToProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :merchant_id
    add_reference :products, :merchant, foreign_key: true
  end
end
