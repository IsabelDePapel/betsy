class AddCvvToBilling < ActiveRecord::Migration[5.1]
  def change
    add_column :billings, :cvv, :string
  end
end
