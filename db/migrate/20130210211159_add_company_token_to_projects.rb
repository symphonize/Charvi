class AddCompanyTokenToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :company_token, :uuid
  end
end
