class RemoveBillingFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :name, :string
    remove_column :users, :email, :string
    remove_column :users, :street1, :string
    remove_column :users, :street2, :string
    remove_column :users, :city, :string
    remove_column :users, :state_prov, :string
    remove_column :users, :zip, :string
    remove_column :users, :country, :string
    remove_column :users, :ccnum, :string
    remove_column :users, :ccmonth, :integer
    remove_column :users, :ccyear, :integer
  end
end
