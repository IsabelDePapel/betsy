class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_save do |category|
    category.name = category.name.downcase
  end

  def self.existing_cat?(string)
   Category.find_by(name: string.downcase) ? (return true) : (return false)
  end

end
