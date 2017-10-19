# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

files = [
  'users.csv',
  'categories.csv',
  'merchants.csv',
  'products.csv',
  'orders.csv',
  'order_items.csv',
  'billings.csv',
  'reviews.csv'
]

classes = [
  User,
  Category,
  Merchant,
  Product,
  Order,
  OrderItem,
  Billing,
  Review
]

files.each_with_index do | file, i |
  media_file = Rails.root.join('db', 'seed_csv', file)


  CSV.foreach(media_file, headers: true, header_converters: :symbol, converters: :all) do |row|
    data = Hash[row.headers.zip(row.fields)]
    puts data
    # a = file[0...-5].capitalize
    # a.constantize
    classes[i].create!(data)
  end
end

CSV.foreach(Rails.root.join('db', 'seed_csv', 'categories_products.csv'), headers: true, header_converters: :symbol, converters: :all) do |row|
  product = Product.find(row[2])
  product.categories << Category.find(row[1])
  product.save
end

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
