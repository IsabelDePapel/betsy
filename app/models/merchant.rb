class Merchant < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :nullify
  has_many :order_items, through: :products

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  validates :user_id, uniqueness: true

  def average_rating
    return if !products # exit if no products

    num_reviews = 0
    rating = 0

    products.each do |product|
      product.reviews.each do |review|
        num_reviews += 1
        rating += review.rating
      end
    end

    # if no reviews
    if num_reviews == 0
      return nil
    else
      return (rating.to_f / num_reviews).round(1)
    end
  end

  def revenue(stat)
    items_billed = self.order_items.where(status: stat)
    revenue = items_billed.sum { |order_item| order_item.price }
    return revenue
  end

  def total_revenue
    total = self.revenue("paid") + self.revenue("complete")
    return total
  end
end
