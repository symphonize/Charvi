class Timesheet < ActiveRecord::Base
  attr_accessible :day, :description, :time, :resource_id, :hours, :minutes, :status_code
  attr_accessor :hours, :minutes, :status_code
  before_save :set_timesheet_time
  
  belongs_to :resource
  
  validates :resource_id, presence: true
  validates :day, presence: true
  
  validates :hours, presence: true
  validates :minutes, presence: true
  
  
  
  
  def hours
    self.time == nil ? 0 : self.time/60
  end
  
  def minutes
    self.time == nil ? 0 : self.time%60 
  end
  
  def status_code
    case self.status
      when 0 then "Saved"
      when 1 then "Submitted"
    end
  end
  
  private
  
  def set_timesheet_time
    self.time= (@hours.to_i * 60) + @minutes.to_i
    self.status = case @status_code
                    when nil then 0
                    when "Saved" then 0
                    when "Submitted" then 1
                  end  
  end
    
end
