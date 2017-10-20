module ApplicationHelper
  def render_price(price)
    number_to_currency(price)
  end

  def display_address(order_object)
    address = order_object.billing
    (
      "<h4> Shipping & Billing Address </h4>
      <strong> #{address.name}</strong>
      <p> #{address.street1}</p>" +
      (address.street2 ? "<p> #{address.street2} </p>" : "") +
      "<p> #{address.city} #{address.state_prov} #{address.zip} </p>
      <p> #{address.country }</p>"
    ).html_safe
  end
  
  def display_cc(order_object)
    address = order_object.billing
    (
      "<p> email: #{address.email}</p>
      <p> CC: XXXX XXXX XXXX #{address.ccnum[-4..-1]} exp: #{address.ccmonth}/#{address.ccyear}</p>"
    ).html_safe
  end
end
