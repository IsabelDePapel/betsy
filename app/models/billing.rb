class Billing < ApplicationRecord
  belongs_to :order
  accepts_nested_attributes_for :order

  # set country to default of USA??
  validates_presence_of :name, :email, :street1, :city, :state_prov, :zip, :country, :ccnum, :ccmonth, :ccyear, :cvv

  validates :cvv, numericality: { only_integer: true, greater_than: 0, less_than: 1000, message: "must be 3 digits" }

  validates :ccmonth, inclusion: 1..12, numericality: { only_integer: true }
  validates :ccyear, numericality: { only_integer: true }

  # validate 1-1 between order and billing
  validates :order_id, uniqueness: true
end
