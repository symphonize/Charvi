class Project < ActiveRecord::Base
  attr_accessible :company_id, :customer_id, :email, :manager, :name, :phone
  belongs_to :company
  
  before_save { |project| project.email = email.downcase }
  
  
end
