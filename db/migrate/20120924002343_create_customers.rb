class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :email
      t.string :website
      t.string :phone
      t.string :fax
      t.string :contact
      t.integer :company_id

      t.timestamps
    end
    add_index :customers, [:company_id]
  end
end
