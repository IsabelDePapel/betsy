class User < ApplicationRecord
  has_one :merchant
  has_one :billing

end
