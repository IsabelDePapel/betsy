class User < ApplicationRecord
  has_one :merchant

  validates :ccmonth, inclusion: 1..12, allow_nil: true
  validates :ccyear, numericality: { only_integer: true }, allow_nil: true
end
