class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :email
      t.string :phone
      t.string :fax
      t.string :website
      t.string :contact
      t.integer :company_id

      t.timestamps
    end
    add_index :vendors, [:company_id]
  end
end
