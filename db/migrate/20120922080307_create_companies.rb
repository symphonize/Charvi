class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :email
      t.string :website
      t.string :phone
      t.string :fax
      t.string :contact

      t.timestamps
    end
  end
end
