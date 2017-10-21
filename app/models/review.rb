class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rating, presence: true
  validates :rating, numericality: { only_integer: true,
                      :greater_than_or_equal_to => 1,
                      :less_than_or_equal_to => 5
                    }
  validate :user_cant_be_product_seller, if: -> { product && user }

  # merchant can't review their own products
  def user_cant_be_product_seller
    if product.merchant.user_id == user_id
      errors.add(:product_id, "can't review your own products")
    end
  end

end
