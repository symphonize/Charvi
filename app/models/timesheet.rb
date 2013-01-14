class Timesheet < ActiveRecord::Base
  attr_accessible :timesheet_day, :description, :overtime, :resource_id, :time
  
  belongs_to :resource
  
  validates :resource_id, presence: true
  validates :timesheet_day, presence: true
  validates :time, presence: true
    
end
