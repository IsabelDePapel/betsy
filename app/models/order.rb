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

  def add_product_to_order(product)
    if product != nil
      # Check if any other order_item has that product
      in_order = false

      self.order_items.each do |item|
        # add to quantity if yes
        if item.product == product
          in_order = true
          existing_order_item = OrderItem.find(item.id)
          existing_order_item.quantity += 1
          existing_order_item.save
        end
      end

      # initialize quantity to 1 if no
      if in_order == false
        order_item = OrderItem.new()
        order_item.quantity = 1
        order_item.product = product
        # Assign it an order
        order_item.order = self
        order_item.save
      end
      return true
    else # product is invalid
      return false
    end
  end

  def remove_order_item_from_order(order_item)
    if order_item != nil
      in_order = false
      self.order_items.each do |item|
        if item == order_item
          in_order = true
          item.destroy
          self.save
        end
      end

      if in_order
        return true
      else  # order_item passed is valid but is not in this order
        return false
      end
    else
      return false
    end
  end

  def change_user(new_user_id)
    self.user = User.find_by(id: new_user_id)
    self.save
  end

  def self.find_last_cart_id(merch_user_id)
    last_order = Order.where(user_id: merch_user_id).order(created_at: :desc)[0]

    if last_order
      if last_order.order_items[0].status == "pending"
        return last_order.id
      else
        return nil
      end
    else
      return nil
    end

  end
end
