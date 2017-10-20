class AddUidAndProviderToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :uid, :string
    add_column :merchants, :provider, :string
  end
end
