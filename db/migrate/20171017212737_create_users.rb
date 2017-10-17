class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state_prov
      t.string :zip
      t.string :country
      t.string :ccnum
      t.date :ccexp

      t.timestamps
    end
  end
end
