class Order < ApplicationRecord
  TAX = 0.101 # tax as a decimal

  belongs_to :user
  has_one :billing, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  def price
    return order_items.sum { |order_item| order_item.price }
  end

  def tax
    return price * TAX
  end

  def total
    return price + tax
  end

  def change_status(new_status)
    OrderItem.where(order_id: id).update_all(status: new_status)
  end

  # TODO must have an order item
  # how do you require > 0 order items when order items depends on order creation?
end
