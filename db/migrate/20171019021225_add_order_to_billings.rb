class AddOrderToBillings < ActiveRecord::Migration[5.1]
  def change
    remove_reference :billings, :user, foreign_key: true
    add_reference :billings, :order, foreign_key: true
  end
end
