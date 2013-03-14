class AddInvoiceSequenceToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_sequence, :integer
  end
end
