module ApplicationHelper
  def readable_price(price)
    number_to_currency(price)
  end
end
