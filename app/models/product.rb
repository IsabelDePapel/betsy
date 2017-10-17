class Product < ApplicationRecord
  belongs_to :merchant
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { maximum: 50 }

  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  validates :description, allow_blank: true, length: { maximum: 225 }
  
end
