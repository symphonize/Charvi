class RemoveUserIdFromCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :user_id
  end
end
