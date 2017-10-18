class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, allow_blank: true, numericality: { greater_than: 0 }
end
