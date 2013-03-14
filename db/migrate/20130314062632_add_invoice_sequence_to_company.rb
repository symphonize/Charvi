class AddInvoiceSequenceToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :invoice_sequence, :integer, default: 0
    
  end
end
