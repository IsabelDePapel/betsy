class User < ApplicationRecord
  has_one :merchant, dependent: :nullify
  has_many :orders, dependent: :nullify

end
