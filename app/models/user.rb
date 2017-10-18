class User < ApplicationRecord
  has_one :merchant

  validates :ccmonth, allow_blank: true, inclusion: 1..12
  validates :ccyear, allow_blank: true, numericality: { only_integer: true }
end
