class TimesheetsController < ApplicationController
  before_filter :signed_in_user
  def index  
    @timesheet = Timesheet.new     
    load_contractors
    if(@contractors != [])
      @contractor_id =  @contractors.first.id
      @projects = Project.joins(:resources).where(company_token: company_token, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
      @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
      @ts_detail = Timesheet.joins({:resource => :project}).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
    else
      @contractor_id = nil      
      @projects = []
      @timesheets = []
      @ts_detail = []
    end     
  end
  
  def destroy
    @timesheet = Timesheet.find_by_id_and_company_token(params[:id], company_token)
    @contractor_id = @timesheet.resource.contractor_id
    @timesheet.destroy
    respond_to do |format|
      format.html {
        flash[:success] = "Time successfully deleted."          
        redirect_to action: 'index'      
      }
      format.js{
        @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
        @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
      }
    end
  end
  
  def select_contractor    
    @timesheet = Timesheet.new
    @contractor_id = params[:contractor]
    load_contractors
    if(@contractors != [])
      @projects = Project.joins(:resources).where(company_token: company_token, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
      @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
      @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
    else
      @projects = []
      @contractors = []
      @timesheets = []
      @ts_detail = []
    end
    render 'index'
  end
  
  def get_time
    @timesheet = Timesheet.new
    @contractor_id = params[:time_contractor_id]   
    if(params[:startDate] != '' && params[:endDate] != '')
     load_contractors
      if(@contractors != [])                        
        @projects = Project.joins(:resources).where(company_token: company_token, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
        @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token, 'timesheets.day' => params[:startDate]..params[:endDate]).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc")
        @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
      else
        @projects = []
        @timesheets = []
        @ts_detail = []
      end   
      render 'index'  
    end
  end
  
  
  def add_new_time
    @timesheet = Timesheet.new(params[:timesheet])
    @timesheet[:company_token] = company_token
    @contractor_id = params[:new_time_contractor_id]
    load_contractors
    if(@contractors != [])
      if @timesheet.save
        respond_to do |format|
          format.html {
            flash[:success] = "New time successfully added."          
            redirect_to action: 'index'      
          }
          format.js{
            @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
            @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
          }
        end
      else      
        flash[:warning] = "Failed to add new time."
        render 'index'
      end
    end    
  end
  def edit
    @timesheet = Timesheet.find_by_id_and_company_token(params[:id], company_token)
    respond_to do |format|
      format.html
      format.js{        
        @contractor_id = @timesheet.resource.contractor_id
        @projects = Project.joins(:resources).where(company_token: company_token, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
      }
    end
  end

def update_time
    @timesheet = Timesheet.find_by_id_and_company_token(params[:id], company_token)
    @timesheet[:company_token] = company_token
    @contractor_id = params[:update_time_contractor_id]
    load_contractors
    if(@contractors != [])
      if @timesheet.update_attributes(params[:timesheet])
        respond_to do |format|
          format.html {
            flash[:success] = "Time successfully updated."          
            redirect_to action: 'index'      
          }
          format.js{
           @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").limit(10)
           @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
          }
        end
      else      
        flash[:warning] = "Failed to update time."
        render 'index'
      end    
    end    
  end


  
  
  private 
  def load_contractors
    if(is_admin? || is_owner? || is_manager?)
      @contractors = Contractor.where(company_token: company_token)
    else
      @contractors = Contractor.where(company_token: company_token, id: current_user.contractor_id)
    end
  end
   
end
