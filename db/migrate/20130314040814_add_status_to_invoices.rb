class AddStatusToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :status, :integer
  end
end
