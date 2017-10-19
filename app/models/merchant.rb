class Merchant < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :nullify

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :user_id, uniqueness: true

  # validate :merchant_cannot_have_user_of_another_merchant
  #
  # #TODO Ask about has_one relationships
  # def merchant_cannot_have_user_of_another_merchant
  #   other_merchants = Merchant.where.not(id: self.id)
  #   other_merchants.each do |merchant|
  #     if merchant.user == self.user
  #       errors.add(:user, "user can't belong to more than one merchant")
  #     end
  #   end
  # end
end
