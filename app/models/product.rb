class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_items, dependent: :nullify
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :nullify

  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :categories

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { maximum: 50 }

  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  validates :quantity, presence: true, numericality: { greater_than: -1 }

  validates :visible, exclusion: { in: [nil] }

  validates :description, allow_blank: true, length: { maximum: 225 }

  def in_stock?
    return quantity > 0
  end

  def average_rating
    num_reviews = reviews.count

    # avoid division by zero if no reviews
    if num_reviews == 0
      return nil
    else
      return (reviews.sum{ |review| review.rating } / num_reviews.to_f).round(1)
    end
  end

  def num_sold
    return OrderItem.where(product_id: Product.find_by(name: name).id).sum { |item| item.quantity }
  end

  # presumes that cat is a category (tested before calling)
  def add_category(cat)
    categories << Category.find_by(name: cat)
  end

  def populate_categories(category_string)
    category_array = category_string.gsub(/^\W*/,"").gsub(/\W*$/,"").split(/\W*,\W*/)
    self.categories = []
    category_array.each do |category|
      if Category.existing_cat?(category)
        add_category(category)
      else
        Category.create(name: category)
        add_category(category)
      end
    end
  end
end
