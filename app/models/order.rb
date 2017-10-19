class Order < ApplicationRecord
  belongs_to :user
  has_one :billing

  # TODO validate that this can only have one billing
end
