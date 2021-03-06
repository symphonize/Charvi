class TimesheetsController < ApplicationController
  before_filter :signed_in_user
  def index  
    @timesheet = Timesheet.new     
    load_contractors
    if(@contractors != [])
      @contractor_id  = params[:contractor]
      if(@contractor_id == nil)
        @contractor_id  = params[:time_contractor_id]
      end
      if(@contractor_id == nil)
        @contractor_id =  @contractors.first.id
      end
      @projects = Project.joins(:resources).where(company_token: company_token, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
      
      if(params[:startDate] != nil && params[:endDate] != nil)     
        if(params[:startDate] != '' && params[:endDate] != '')
          @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token, 'timesheets.day' => params[:startDate]..params[:endDate]).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").page(params[:page]).per_page(7)
          @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
        else
          @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").page(params[:page]).per_page(7)
          @ts_detail = Timesheet.joins({:resource => :project}).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
        end
      else      
        @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").page(params[:page]).per_page(7)
        @ts_detail = Timesheet.joins({:resource => :project}).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
      end
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
    if(@timesheet.status < 2)
      @timesheet.destroy
    end
    @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").page(params[:page]).per_page(7)
    @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
    @projects = Project.joins(:resources).where(company_token: company_token, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
    render 'index'
  end
  def new
    @timesheet = Timesheet.new
    @timesheet[:status] = 1
    load_contractors
    if(@contractors != [])
      @contractor_id  = params[:contractor_id]
      if(@contractor_id == nil)
        @contractor_id =  @contractors.first.id
      end
      @projects = Project.joins(:resources).where(company_token: company_token, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
  def add_new_time
    @timesheet = Timesheet.new(params[:timesheet])
    @timesheet[:company_token] = company_token
    @contractor_id = params[:new_time_contractor_id]
    load_contractors
    if(@contractors != [])
      if @timesheet.save
        @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").page(params[:page]).per_page(7)
        @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
        @projects = Project.joins(:resources).where(company_token: company_token, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
        render 'index'
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
      if(@timesheet.status < 2)
        if @timesheet.update_attributes(params[:timesheet])
          @timesheets = Timesheet.joins(:resource).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("date(timesheets.day)as day, sum(timesheets.time)/60.0 as total_hours").group("date(day)").order("date(day) desc").page(params[:page]).per_page(7)
          @ts_detail = Timesheet.joins(:resource => :project).where('resources.contractor_id'=>@contractor_id, company_token: company_token).select("timesheets.id, date(timesheets.day) as day, timesheets.time/60.0 as time_hour, timesheets.description, projects.name, timesheets.status")
          @projects = Project.joins(:resources).where(company_token: company_token, 'resources.contractor_id' => @contractor_id).select("projects.name, resources.id")
          render 'index'
        else      
          flash[:warning] = "Failed to update time."
          render 'index'
        end
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
