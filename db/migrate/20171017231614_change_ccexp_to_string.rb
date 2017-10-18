class ChangeCcexpToString < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :ccexp, :string
  end
end
