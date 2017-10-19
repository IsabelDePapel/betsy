class DropTableCatProdJoins < ActiveRecord::Migration[5.1]
  def change
    drop_table :categories_products_joins
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end

end
