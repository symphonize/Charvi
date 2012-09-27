class Resource < ActiveRecord::Base
  attr_accessible :billing_amount, :billing_type, :contractor_id, :project_id
  
  belongs_to :project
  
  validates :project_id, presence: true
  validates :contractor_id, presence: true
  validates :billing_type, presence: true
  
  validates :billing_amount, presence: true, 
      format: { with: /^\d+??(?:\.\d{0,2})?$/ }, numericality: {greater_than: 0, less_than: 10}
  
  default_scope order: 'resources.project_id'
    
end
