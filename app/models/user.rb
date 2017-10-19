class User < ApplicationRecord
  has_one :merchant, dependent: :nullify

end
