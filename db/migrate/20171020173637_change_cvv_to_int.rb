class ChangeCvvToInt < ActiveRecord::Migration[5.1]
  def change
    remove_column :billings, :cvv, :string
    add_column :billings, :cvv, :integer
  end
end
