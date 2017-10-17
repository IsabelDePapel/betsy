class MakeCcexpTwoCols < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :ccexp, :string
    add_column :users, :ccmonth, :string
    add_column :users, :ccyear, :string
  end
end
