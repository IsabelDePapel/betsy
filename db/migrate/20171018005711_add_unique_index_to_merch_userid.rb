class AddUniqueIndexToMerchUserid < ActiveRecord::Migration[5.1]
  def change
    remove_index :merchants, :user_id
    add_index :merchants, :user_id, unique: true
  end
end
