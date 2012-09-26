class RemoveUserIdToCustomers < ActiveRecord::Migration
  def up
    remove_column :customers, :user_id
  end  
end
