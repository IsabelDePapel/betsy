module ApplicationHelper
  def readable_price(price)
    number_to_currency(price)
  end

  def get_name(user)
    if user.merchant == nil
      return "Anonymous"
    else
      return user.merchant.username
    end
  end

  def readable_date(date)
    # return a string of the HTML I want to put in the view
    # Parenthesis cleanses the HTML
      if date != nil
        return date.strftime('%b %-d, %Y')
      else
        return ""
      end
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

  def return_visible_products(category)
    return category.products.where("visible = 'true'")
  end

  def potato
    return "https://vignette1.wikia.nocookie.net/adventuretimewithfinnandjake/images/9/93/Potato-potato.jpg/revision/latest?cb=20120411031630"
  end

  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end

  def asset_exist?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include? path
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end
end
