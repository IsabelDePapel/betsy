class CreateBillings < ActiveRecord::Migration[5.1]
  def change
    create_table :billings do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :email
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state_prof
      t.string :zip
      t.string :country
      t.string :ccnum
      t.integer :ccmonth
      t.integer :ccyear

      t.timestamps
    end
  end
end
