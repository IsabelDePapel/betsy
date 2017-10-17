class AddDefaultVisibleToProduct < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :visible, :boolean, default: false
  end
end
