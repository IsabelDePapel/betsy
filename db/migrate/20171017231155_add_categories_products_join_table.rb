class AddCategoriesProductsJoinTable < ActiveRecord::Migration[5.1]
  def change #categories_products
    create_table :categories_products_joins do |t|
      # new migration file
      create_table :categories_products do |t|
        t.belongs_to :category, index: true
        t.belongs_to :product, index: true
        t.timestamps
      end
    end
  end
end
