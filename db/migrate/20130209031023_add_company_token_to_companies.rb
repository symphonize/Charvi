class AddCompanyTokenToCompanies < ActiveRecord::Migration
  def change
    add_column :companies,:company_token, :uuid    
  end
end
