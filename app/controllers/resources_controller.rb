class ResourcesController < ApplicationController
before_filter :signed_in_power_user
  
  def index
    @projects = Project.where(company_token: company_token) 
    if(@projects != [])   
      @project_id =  @projects.first.id
      @resources = Resource.where(project_id: @project_id)
    else
      @project_id = nil
      @resources = []
    end
  end
  def select_project    
    @project_id = params[:project]
    @projects = Project.where(company_token: company_token)
    if(@projects != [])      
      @resources = Resource.where(project_id: @project_id, company_token: company_token)      
    else
      @resources = []            
    end 
    render 'index'
  end
  
  def show
    @resource = Resource.find_by_id_and_company_token(params[:id], company_token) 
  end
  
  def edit
      @resource = Resource.find_by_id_and_company_token(params[:id], company_token)      
      @projects = Project.where(company_token: company_token)
      @contractors = Contractor.where(company_token: company_token)  
  end

  def new      
      @resource = Resource.new
      @projects = Project.where(company_token: company_token)
      @contractors = Contractor.where(company_token: company_token)
  end
  
  def create
    @resource = Resource.new(params[:resource])
    @resource[:company_token] = company_token
    if @resource.save
      flash[:success] = "New resource successfully added."
      redirect_to @resource
    else          
      render 'new'
    end
  end
  
  def update
    @resource = Resource.find(params[:id])  
    if @resource.update_attributes(params[:resource])
      flash.now[:success] = "Resource updated"
      render 'show'
    else
      render 'edit'
    end
  end
end
