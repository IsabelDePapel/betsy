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
  # updates and returns empty hash if successful; else errors hash
  # (couldn't add errors using rails)
  def update_inventory
    # iterates through items once to confirm all inventory there before updating
    order_items.each do |item|
      inventory = item.product.quantity

      if inventory < item.quantity
        change_status("pending")
        return {name: item.product.name, qty: item.product.quantity}
      end
    end

    # iterates again to update
    order_items.each do |item|
      item.update_product_quantity
    end

    return {} # if no errors to return
  end

  def add_product_to_order(prod, amount_ordered)
    if prod != nil && self.is_cart?
      # Check if any other order_item has that product
      in_order = false
      self.order_items.each do |item|
        # add to quantity if yes

        if item.product.id == prod.id
          in_order = true
          existing_order_item = OrderItem.find(item.id)
          existing_order_item.quantity += amount_ordered.to_i
          if !existing_order_item.save
            return false
          end
        end
      end

      # initialize quantity to 1 if no
      if in_order == false
        order_item = OrderItem.new()
        order_item.quantity = amount_ordered
        order_item.product = prod
        # order_item.order = self # does not explicitly tell order it has a new order_item BUT order_item knows it belongs to an order
        # order_item.save

        # Assign it an order
        self.order_items << order_item
      end

      return true
    else # product is invalid
      return false
    end
  end

  def remove_order_item_from_order(order_item)
    if order_item != nil && self.is_cart?
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

    return nil unless last_order
    last_order.is_cart? ? (return last_order.id) : (return nil)

  end

  def is_cart?
    self.order_items.each do |item|
      if item.status != "pending"
        return false
      end
    end
    return true
  end

end
