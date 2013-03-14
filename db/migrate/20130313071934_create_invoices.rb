class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :invoice_no
      t.integer :customer_id      
      t.string :customer_contact
      t.string :customer_address
      t.string :company_contact
      t.string :company_address
      t.date :invoice_date
      t.date :due_date
      t.decimal :invoice_amount

      t.timestamps
    end
  end
end
