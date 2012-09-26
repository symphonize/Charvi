class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :manager
      t.string :email
      t.string :phone
      t.integer :company_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
