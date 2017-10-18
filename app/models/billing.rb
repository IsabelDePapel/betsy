class Billing < ApplicationRecord
  belongs_to :user

  # set country to default of USA??
  validates_presence_of :name, :email, :street1, :city, :state_prov, :zip, :country, :ccnum, :ccmonth, :ccyear

  validates :ccmonth, inclusion: 1..12, numericality: { only_integer: true }
  validates :ccyear, numericality: { only_integer: true }
end
