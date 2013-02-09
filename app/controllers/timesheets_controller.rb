class TimesheetsController < ApplicationController
  before_filter :signed_in_user
  def index  
    @timesheet = Timesheet.new  
    if user_companies != [] 
      @company_id = user_companies.first.id  
      if(user_companies.first.contractors != [])
        @contractors = user_companies.first.contractors
        @contractor_id =  user_companies.first.contractors.first.id
        @projects = Project.joins(:resources).where(company_id: @company_id, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
        @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
        @ts_detail = Timesheet.joins({:resource => :project}).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
        
      else
        @contractor_id = nil
        @contractors = []
        @projects = []
        @timesheets = []
        @ts_detail = []
      end
    else
        @company_id =nil
        @contractor_id = nil
        @projects = []
        @contractors = []
        @timesheets = []
        @ts_detail = []
    end        
  end
  
  def destroy
    redirect_t action: 'index'
  end
  
  
    def select_company
    @company_id = params[:company]
    @timesheet = Timesheet.new
    if Company.where(id: @company_id, user_id: current_user.id) != []
      if(current_user.contractors.where(company_id: @company_id) != [])
        @contractors = current_user.contractors.where(company_id: @company_id)
        @contractor_id = current_user.contractors.where(company_id: @company_id).first.id
        @projects = Project.joins(:resources).where(company_id: @company_id, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
        @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
        @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")        
      else
        @contractors = []
        @projects = []
        @contractor_id =nil
        @timesheets = []
        @ts_detail = []        
      end    
    else
        @contractors = []
        @projects = []
        @company_id =nil
        @contractor_id =nil
        @timesheets = []
        @ts_detail = []        
    end    
    render 'index'
  end
  
  def select_contractor    
    @timesheet = Timesheet.new    
    @company_id = params[:contractor_company_id]
    @contractor_id = params[:contractor]    
    if Company.where(id: @company_id, user_id: current_user.id) != []
      if(Contractor.where(id: @contractor_id, company_id: @company_id) != [])
        @contractors = Contractor.where(company_id: @company_id)                
        @projects = Project.joins(:resources).where(company_id: @company_id, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
        @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
        @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
       
        #@timesheet = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, 'timesheets.day' => params[:startDate]..params[:endDate]).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc")
        #@ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time, timesheets.description, projects.name, timesheets.status")
      else
        @contractor_id = nil
        @projects = []
        @contractors = []
        @timesheets = []
        @ts_detail = []
      end
    else
        @company_id =nil
        @projects = []
        @contractor_id = nil
        @contractors = []
        @timesheets = []
        @ts_detail = []
    end        
    render 'index'
  end
  
  def get_time
    @timesheet = Timesheet.new    
    @company_id = params[:time_company_id]
    @contractor_id = params[:time_contractor_id]   
    if(params[:startDate] != '' && params[:endDate] != '') 
      if Company.where(id: @company_id, user_id: current_user.id) != []
        if(Contractor.where(id: @contractor_id, company_id: @company_id) != [])
          @contractors = Contractor.where(company_id: @company_id)                
          @projects = Project.joins(:resources).where(company_id: @company_id, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
          
          @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, 'timesheets.day' => params[:startDate]..params[:endDate]).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc")
          @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
        else
          @contractor_id = nil
          @projects = []
          @contractors = []
          @timesheets = []
          @ts_detail = []
        end
      else
          @company_id =nil
          @projects = []
          @contractor_id = nil
          @contractors = []
          @timesheets = []
          @ts_detail = []
      end        
      render 'index'
    end
  end
  
  
  def add_new_time
    @timesheet = Timesheet.new(params[:timesheet])
    hours = params[:hours]
    minutes = params[:minutes]
    @timesheet[:time] = params[:hours].to_i * 60 + params[:minutes].to_i    
    @timesheet[:overtime] = false;
    @company_id = params[:new_time_company_id]
    @contractor_id = params[:new_time_contractor_id]
    if Company.where(id: @company_id, user_id: current_user.id) != []
      if(Contractor.where(id: @contractor_id, company_id: @company_id) != [])
        if @timesheet.save
          respond_to do |format|
            format.html {
              flash[:success] = "New time successfully added."          
              redirect_to action: 'index'      
            }
            format.js{
              @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
              @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
            }
          end
        else      
          flash[:warning] = "Failed to add new time."
              @contractors = Contractor.where(company_id: @company_id)
              @projects = Project.joins(:resources).where(company_id: @company_id, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
              @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
              @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
          render 'index'
        end
      end
    end
  end
  
  
  
  private 
  def index_load
    
    
  end
   
end
