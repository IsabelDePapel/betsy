class AddCcInfoAsInts < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :ccmonth, :integer
    add_column :users, :ccyear, :integer
  end
end
