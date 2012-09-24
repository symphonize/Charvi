class CreateContractors < ActiveRecord::Migration
  def change
    create_table :contractors do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :email
      t.string :phone
      t.string :fax
      t.integer :company_id

      t.timestamps
    end
    add_index :contractors, [:company_id]
  end
end
