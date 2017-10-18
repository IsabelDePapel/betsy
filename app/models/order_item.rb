class OrderItem < ApplicationRecord
  # add cart to status array--track cart orders that way???
  STATUSES = %w(pending paid complete canceled)

  belongs_to :order
  belongs_to :product

  validates :status, inclusion: { in: STATUSES}
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
