class ChangeCcInfoToInts < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :ccmonth, :integer
    remove_column :users, :ccyear, :integer
  end
end
