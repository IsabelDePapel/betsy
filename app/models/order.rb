class Order < ApplicationRecord
  belongs_to :user
  has_one :billing, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # TODO must have an order item
  # how do you require > 0 order items when order items depends on order creation?

  def change_status(new_status)
    order_items.each do |item|
      item.status = new_status
      item.save
    end
  end
end
