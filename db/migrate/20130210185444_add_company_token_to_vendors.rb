class AddCompanyTokenToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :company_token, :uuid
  end
end
