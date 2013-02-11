class AddCompanyTokenToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :company_token, :uuid
  end
end
