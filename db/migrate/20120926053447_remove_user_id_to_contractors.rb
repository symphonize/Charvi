class RemoveUserIdToContractors < ActiveRecord::Migration
  def up
    remove_column :contractors, :user_id
  end
end
