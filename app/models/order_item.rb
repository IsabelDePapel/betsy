class OrderItem < ApplicationRecord
  # add cart to status array--track cart orders that way???
  STATUSES = %w(pending paid complete canceled)
  # Only subtract when you check-out

  belongs_to :order
  belongs_to :product

  validates :status, inclusion: { in: STATUSES}
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :cannot_add_an_order_item_if_more_than_quantity


  def cannot_add_an_order_item_if_more_than_quantity
    if self.product.quantity < self.quantity
      errors.add(:order_item, "user can't order item with quantity more than the available product inventory")
    end
  end

  #everything has to be in a method

  def update_product_quantity
    if self.status == "paid"
      self.product.quantity -= self.quantity
    end
  end

end
