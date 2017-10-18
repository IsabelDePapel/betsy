class User < ApplicationRecord
  has_one :merchant

  validates :ccmonth, inclusion: 1..12
  validates :ccyear, numericality: { only_integer: true }
end
