class AddOrderfkToOrderitems < ActiveRecord::Migration[5.1]
  def change
    remove_column :order_items, :order_id
    add_reference :orders, :order_items, foreign_key: true
  end
end
