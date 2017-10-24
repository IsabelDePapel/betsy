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

  # presumes that cat is a category (tested before calling)
  def add_category(cat)
    categories << Category.find_by(name: cat)
  end
end
