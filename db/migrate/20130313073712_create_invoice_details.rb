class CreateInvoiceDetails < ActiveRecord::Migration
  def change
    create_table :invoice_details do |t|
      
      t.integer :invoice_id
      t.integer :contractor_id
      t.integer :time
      t.decimal :billing_amount      

      t.timestamps
    end
  end
end
