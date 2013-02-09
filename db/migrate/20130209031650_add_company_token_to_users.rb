class AddCompanyTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_token, :uuid    
  end
end
