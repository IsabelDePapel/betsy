class Billing < ApplicationRecord
  belongs_to :order

  # set country to default of USA??
  validates_presence_of :name, :email, :street1, :city, :state_prov, :zip, :country, :ccnum, :ccmonth, :ccyear

  validates :ccmonth, inclusion: 1..12, numericality: { only_integer: true }
  validates :ccyear, numericality: { only_integer: true }

  # validate 1-1 between order and billing
  validates :order_id, uniqueness: true
end
