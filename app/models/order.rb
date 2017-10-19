class Order < ApplicationRecord
  belongs_to :user
  has_one :billing
  has_many :order_items
  has_many :products, through: :order_items


  # TODO must have an order item
  # how do you require > 0 order items when order items depends on order creation?
end
