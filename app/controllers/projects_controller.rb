class ProjectsController < ApplicationController
 before_filter :signed_in_power_user
  
  def index    
    if company_token != nil 
      @projects = Project.where(company_token: company_token)
    else
      @projects = []
    end        
  end
  
  def show
    if company_token != nil
      @project = Project.find_by_id_and_company_token(params[:id], company_token)
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
    if company_token != nil
      @project = Project.find_by_id_and_company_token(params[:id], company_token)
      @customers = Customer.where(company_token: company_token)
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
    if company_token == nil
      flash[:warning] = NO_COMPANIES_WARNING
      redirect_to action:'index'
    else
      @project = Project.new
      @customers = Customer.where(company_token: company_token)
    end
  end
  
  def create
    @project = Project.new(params[:project])
    @project[:company_token] = company_token
      if(Customer.where(id: @project.customer_id, company_token: company_token) != [] )        
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
  end
  
  def update
    @project = Project.find(params[:id])  
    if(Customer.where(id: @project.customer_id, company_token: company_token) != [])        
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