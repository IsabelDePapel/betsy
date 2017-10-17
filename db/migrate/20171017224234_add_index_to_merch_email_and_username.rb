class AddIndexToMerchEmailAndUsername < ActiveRecord::Migration[5.1]
  def change
    # add index to username and email to enforce uniqueness on db level
    add_index :merchants, :email, unique: true
    add_index :merchants, :username, unique: true
  end
end
