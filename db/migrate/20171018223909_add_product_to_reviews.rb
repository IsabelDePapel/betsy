class AddProductToReviews < ActiveRecord::Migration[5.1]
  def change
    remove_column :reviews, :product_id
    add_reference :reviews, :product, foreign_key: true
  end
end
