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
    # exit if new_status not valid
    return if !OrderItem::STATUSES.include? new_status

    # doesn't trigger validations
    OrderItem.where(order_id: id).update_all(status: new_status, updated_at: DateTime.now)
  end

  # clean this up??
  def update_inventory
    # confirm order_item status is paid
    order_items.each do |item|
      if item.status == "paid"
        item.product.quantity -= item.quantity

        # if inventory update fails
        if !item.product.save
          flash[:status] = :error
          flash[:message] = "There was a problem with your order"
          flash[:details] = item.product.errors.messages

          redirect_to cart_path
        end
      end
    end
  end

  # TODO must have an order item
  # how do you require > 0 order items when order items depends on order creation?
end
