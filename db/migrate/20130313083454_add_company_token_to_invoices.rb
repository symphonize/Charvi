class AddCompanyTokenToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :company_token, :uuid
  end
end
