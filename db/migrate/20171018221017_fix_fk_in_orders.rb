class FixFkInOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :orders, :order_items, foreign_key: true
  end
end
