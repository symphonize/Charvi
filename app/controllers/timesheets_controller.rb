class TimesheetsController < ApplicationController
  before_filter :signed_in_user
  def index  
    @new_timesheet = Timesheet.new  
    if user_companies != [] 
      @company_id = user_companies.first.id  
      if(user_companies.first.contractors != [])
        @contractors = user_companies.first.contractors
        @contractor_id =  user_companies.first.contractors.first.id
        @projects = Project.joins(:resources).where(company_id: @company_id, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
        @timesheet = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
        @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time, timesheets.description, projects.name, timesheets.status")
        
      else
        @contractor_id = nil
        @contractors = []
        @projects = []
        @timesheet = []
        @ts_detail = []
      end
    else
        @company_id =nil
        @contractor_id = nil
        @projects = []
        @contractors = []
        @timesheet = []
        @ts_detail = []
    end        
  end
  
    def select_company
    @company_id = params[:company]
    @new_timesheet = Timesheet.new
    if Company.where(id: @company_id, user_id: current_user.id) != []
      if(current_user.contractors.where(company_id: @company_id) != [])
        @contractors = current_user.contractors.where(company_id: @company_id)
        @contractor_id = current_user.contractors.where(company_id: @company_id).first.id
        @projects = Project.joins(:resources).where(company_id: @company_id, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
        @timesheet = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
        @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time, timesheets.description, projects.name, timesheets.status")        
      else
        @contractors = []
        @projects = []
        @contractor_id =nil
        @timesheet = []
        @ts_detail = []        
      end    
    else
        @contractors = []
        @projects = []
        @company_id =nil
        @contractor_id =nil
        @timesheet = []
        @ts_detail = []        
    end    
    render 'index'
  end
  
  def select_contractor
    @new_timesheet = Timesheet.new
    if user_companies != [] 
      @company_id = user_companies.first.id  
      if(user_companies.first.contractors != [])   
        @contractors = user_companies.first.contractors
        @contractor_id =  params[:contractor]
        @projects = Project.joins(:resources).where(company_id: @company_id, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
        @timesheet = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
        @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time, timesheets.description, projects.name, timesheets.status")
      else
        @contractor_id = nil
        @projects = []
        @contractors = []
        @timesheet = []
        @ts_detail = []
      end
    else
        @company_id =nil
        @projects = []
        @contractor_id = nil
        @contractors = []
        @timesheet = []
        @ts_detail = []
    end        
    render 'index'
  end
  
  def add_new_time
    @timesheet = Timesheet.new(params[:new_timesheet])
    
    @timesheet[:time] = @timesheet[:time] * 60
    
    if @timesheet.save
      flash[:success] = "New time successfully added."
      redirect_to action: 'index'
    else
      if user_companies != [] 
        @company_id = user_companies.first.id  
        if(user_companies.first.contractors != [])
          @contractors = user_companies.first.contractors
          @contractor_id =  user_companies.first.contractors.first.id
          @projects = Project.joins(:resources).where(company_id: @company_id, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
          @timesheet = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
          @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time, timesheets.description, projects.name, timesheets.status")
          
        else
          @contractor_id = nil
          @contractors = []
          @projects = []
          @timesheet = []
          @ts_detail = []
        end
      else
          @company_id =nil
          @contractor_id = nil
          @projects = []
          @contractors = []
          @timesheet = []
          @ts_detail = []
      end        
      render 'index'
    end
    
    
  end
  
  
  
  private 
  def index_load
    
    
  end
   
end
