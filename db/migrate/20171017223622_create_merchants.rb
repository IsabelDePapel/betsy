class CreateMerchants < ActiveRecord::Migration[5.1]
  def change
    create_table :merchants do |t|
      t.references :user, foreign_key: true
      t.string :username
      t.string :email

      t.timestamps
    end
  end
end
