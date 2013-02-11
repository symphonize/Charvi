class AddCompanyTokenToContractors < ActiveRecord::Migration
  def change
    add_column :contractors, :company_token, :uuid
  end
end
