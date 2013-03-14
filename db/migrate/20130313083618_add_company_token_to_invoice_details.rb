class AddCompanyTokenToInvoiceDetails < ActiveRecord::Migration
  def change
    add_column :invoice_details, :company_token, :uuid
  end
end
