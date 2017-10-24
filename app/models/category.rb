class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true

  def self.existing_cat?(string)
    return true if Category.find_by(name: string)
  end
end
