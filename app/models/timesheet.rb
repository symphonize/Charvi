class Timesheet < ActiveRecord::Base
  attr_accessible :day, :description, :time, :resource_id, :hours, :minutes
  attr_accessor :hours, :minutes
  before_save :set_timesheet_time
  
  belongs_to :resource
  
  validates :resource_id, presence: true
  validates :day, presence: true
  
  validates :hours, presence: true
  validates :minutes, presence: true
  
  
  private
  
  def hours
    self.time == nil ? 0 : self.time/60
  end
  
  def minutes
    self.time == nil ? 0 : self.time%60 
  end
  
  def set_timesheet_time
    self.time= (@hours.to_i * 60) + @minutes.to_i
  end
    
end
