class AddProjectIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :project_id, :integer, default:nil
  end
end
