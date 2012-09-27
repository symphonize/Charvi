class ResourcesController < ApplicationController
before_filter :signed_in_user
  
  def index    
    if user_companies != [] 
      @company_id = user_companies.first.id  
      if(user_companies.first.projects != [])   
        @project_id =  user_companies.first.projects.first.id
        @projects = user_companies.first.projects
        @resources = Resource.where(project_id: @project_id)
      else
        @project_id = nil
        @projects = nil
        @resources = []
      end
    else
        @company_id =nil
        @project_id = nil
        @projects = nil
        @resources = []
    end        
  end
  
  def select_project
    @company_id = params[:company]
    @project_id = params[:project]
    if Company.where(id: @company_id, user_id: current_user.id) != []
      if Project.where(id: @project_id, company_id: @company_id) != []
        @projects = Project.where(company_id: @company_id)        
        @resources = Resource.where(project_id: @project_id)
      else
        @company_id =nil
        @project_id =nil
        @projects = []
        @resources = []
      end
    else
        @company_id =nil
        @projects = []
        @project_id =nil
        @resources = []
    end    
    render 'index'
  end
  
  def select_company
    @company_id = params[:company]
    
    if Company.where(id: @company_id, user_id: current_user.id) != []
      @project_id = user_companies.find(@company_id).projects.first.id
      if Project.where(id: @project_id, company_id: @company_id) != []
        @resources = Resource.where(project_id: @project_id)
      else
        @company_id =nil
        @project_id =nil
        @resources = []
      end
    else
        @company_id =nil
        @project_id =nil
        @resources = []
    end    
    render 'index'
  end
  
  
  
  def show
    if user_companies != []
      @project = current_user.projects.find_by_id(params[:id])
      if @project == nil
        flash[:warning] = ACCESS_FAILURE_WARNING
        redirect_to action:'index'  
      end   
    else
      flash[:warning] = ACCESS_FAILURE_WARNING
      redirect_to action:'index'
    end 
  end
  
  def edit
    if user_companies != []
      @project = current_user.projects.find_by_id(params[:id])
      @customers = current_user.customers
      if @project == nil
        flash[:warning] = ACCESS_FAILURE_WARNING
        redirect_to action:'index'      
      end           
    else
      flash[:warning] = ACCESS_FAILURE_WARNING
      redirect_to action:'index'
    end    
  end

  def new
    if(user_companies == [])
      flash[:warning] = NO_COMPANIES_WARNING
      redirect_to action:'index'
    else
      @project = Project.new
      @customers = current_user.customers
    end
  end
  
  def create
    @project = Project.new(params[:project])
    if Company.where(id: @project.company_id, user_id: current_user.id) != []
      if(current_user.customers.where(id: @project.customer_id) != [] )        
        if @project.save
          flash[:success] = "New project successfully added."
          redirect_to @project
        else
          render 'new'
        end
      else
        flash[:warning] = ACCESS_FAILURE_WARNING
        redirect_to action:'index'
      end
    else
      flash[:warning] = ACCESS_FAILURE_WARNING
      redirect_to action:'index'
    end 
  end
  
  def update
    @project = current_user.projects.find(params[:id])  
    if(current_user.customers.where(id: @project.customer_id) != [])        
      if @project.update_attributes(params[:project])
        flash.now[:success] = "Project updated"
        render 'show'
      else
        render 'edit'
      end
    else
      flash[:warning] = ACCESS_FAILURE_WARNING
      redirect_to action:'index'
    end      
  end
end
