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
    @company_id = params[:resource][:company_id]
    @project_id = params[:project]
    if Company.where(id: @company_id, user_id: current_user.id) != []
      if(current_user.projects.where(company_id: @company_id) != [])
        @projects = current_user.projects.where(company_id: @company_id)
        @resources = Resource.where(project_id: @project_id)
        @error = ""
      else
        @projects = []        
        @resources = []
        @project_id =nil
        @error = "no projects"
      end    
    else
        @projects = []
        @company_id =nil
        @project_id =nil
        @resources = []
        @error = @company_id
    end    
    render 'index'
  end
  
  def select_company
    @company_id = params[:company]
    
    if Company.where(id: @company_id, user_id: current_user.id) != []
      if(current_user.projects.where(company_id: @company_id) != [])
        @projects = current_user.projects.where(company_id: @company_id)
        @project_id = current_user.projects.where(company_id: @company_id).first.id
        @resources = Resource.where(project_id: @project_id)
      else
        @projects = []        
        @resources = []
        @project_id =nil
      end    
    else
        @projects = []
        @company_id =nil
        @project_id =nil
        @resources = []
    end    
    render 'index'
  end
  
  def show
    @resource = Resource.find_by_id(params[:id])
    if(current_user.projects.where(id: @resource.project_id) != [])
      if(current_user.contractors.where(id: @resource.contractor_id) == [])
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
      @resource = Resource.find_by_id(params[:id])
      @company_id = Project.find(@resource.project_id).company_id
      @projects = current_user.projects
      @contractors = current_user.contractors
      if Company.where(id: @company_id, user_id: current_user.id) != []
        if(current_user.contractors.where(id: @resource.contractor_id) != [] )
          if @resource == nil
            flash[:warning] = ACCESS_FAILURE_WARNING
            redirect_to action:'index'      
          end  
        else        
          flash[:warning] = ACCESS_FAILURE_WARNING
          redirect_to action:'index'
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

  def new
    if(user_companies == [])
      flash[:warning] = NO_COMPANIES_WARNING
      redirect_to action:'index'
    else
      @company_id = user_companies.first.id
      @resource = Resource.new
      @projects = current_user.projects
      @contractors = current_user.contractors
    end
  end
  
  def select_company_new
    @company_id = params[:company]    
    if Company.where(id: @company_id, user_id: current_user.id) != []
      if(current_user.projects.where(company_id: @company_id) != [])
        @projects = current_user.projects.where(company_id: @company_id)
        if(current_user.contractors.where(company_id: @company_id) != [])
          @contractors = current_user.contractors.where(company_id: @company_id)
          @resource = Resource.new
        else
          flash.now[:warning] = NO_CONTRACTORS_WARNING
          @resource = Resource.new
          @contractors = []
        end
      else
        flash.now[:warning] = NO_PROJECTS_WARNING
        @projects = []
        @resource = Resource.new
        @contractors = []        
      end    
    else
      flash.now[:warning] = NO_PROJECTS_WARNING
      @projects = []
      @resource = Resource.new
      @contractors = []
    end    
    render 'new'
  end
  
  def select_company_edit
    @company_id = params[:company]    
    if Company.where(id: @company_id, user_id: current_user.id) != []
      if(current_user.projects.where(company_id: @company_id) != [])
        @projects = current_user.projects.where(company_id: @company_id)
        if(current_user.contractors.where(company_id: @company_id) != [])
          @contractors = current_user.contractors.where(company_id: @company_id)
          @resource = Resource.find_by_id(params[:id])
        else
          flash.now[:warning] = NO_CONTRACTORS_WARNING
          @resource = Resource.find_by_id(params[:id])
          @contractors = []
        end
      else
        flash.now[:warning] = NO_PROJECTS_WARNING
        @projects = []
        @resource = Resource.find_by_id(params[:id])
        @contractors = []        
      end    
    else
      flash.now[:warning] = NO_PROJECTS_WARNING
      @projects = []
      @resource = Resource.find_by_id(params[:id])
      @contractors = []
    end    
    render 'edit'
  end
  
  def create
    @resource = Resource.new(params[:resource])
    @company_id = Project.find(@resource.project_id).company_id
    if Company.where(id: @company_id, user_id: current_user.id) != []
      if(current_user.contractors.where(id: @resource.contractor_id) != [] )        
        if @resource.save
          flash[:success] = "New resource successfully added."
          redirect_to @resource
        else
          @projects = current_user.projects.where(company_id: @company_id)
          @contractors = current_user.contractors.where(company_id: @company_id)
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
    @resource = Resource.find(params[:id])  
    if(current_user.projects.where(id: @resource.project_id) != [])
      if(current_user.contractors.where(id: @resource.contractor_id) != [])
        if @resource.update_attributes(params[:resource])
          flash.now[:success] = "Resource updated"
          render 'show'
        else
          render 'edit'
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
end
