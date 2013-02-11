class AddCompanyTokenToResources < ActiveRecord::Migration
  def change
    add_column :resources, :company_token, :uuid
  end
end
