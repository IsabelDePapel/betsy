class OrderItem < ApplicationRecord
  # add cart to status array--track cart orders that way???
  STATUSES = %w(pending paid complete canceled)
  # Only subtract when you check-out

  belongs_to :order
  belongs_to :product

  validates :status, inclusion: { in: STATUSES}
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :cannot_add_an_order_item_if_more_than_quantity, if: -> { product && quantity }


  def cannot_add_an_order_item_if_more_than_quantity
    if self.product.quantity < self.quantity
      errors.add(:order_item, "user can't order item with quantity more than the available product inventory")
    end
  end

  #everything has to be in a method
  # returns nil if unchanged, true if canceled, else false
  def cancel_order
    # change status and add item qty back to inventory
    if self.status != "canceled"
      self.status = "canceled"
      self.product.quantity += self.quantity
      self.product.save

      return self.save
    end

    return nil
  end

  def uncancel_order(new_status)
    # check if enough inventory to uncancel, then change status and update inventory
    return nil if self.status == new_status

    if self.status == "canceled" && new_status != "canceled"
      if self.quantity <= self.product.quantity
        self.status = new_status
        self.product.quantity -= self.quantity
        self.product.save
      end
    else
      self.status = new_status
    end

    return self.save
  end

  # changes status and updates inventory as appropriate
  def change_status(new_status)
    if new_status == "canceled"
      return cancel_order
    else
      return uncancel_order(new_status)
    end
  end

  def update_product_quantity(canceled = false)
    # add order item qty to inventory if order canceled
    if canceled
      if self.status == "canceled"
        self.product.quantity += self.quantity
        self.product.save
      end
    # if order paid and enough inventory, subtract order item qty from inventory
    else
      if self.status == "paid" && self.quantity <= self.product.quantity
        self.product.quantity -= self.quantity
        self.product.save
      end
    end
  end

  def price
    return quantity * product.price
  end

end
