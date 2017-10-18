class FixTypoInBilling < ActiveRecord::Migration[5.1]
  def change
    rename_column :billings, :state_prof, :state_prov
  end
end
