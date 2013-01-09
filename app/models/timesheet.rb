class Timesheet < ActiveRecord::Base
  attr_accessible :day, :description, :overtime, :resource_id, :time
  
  belongs_to :resource
  
  validates :resource_id, presence: true
  validates :day, presence: true
  validates :time, presence: true
    
end
