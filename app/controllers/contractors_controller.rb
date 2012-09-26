class ContractorsController < ApplicationController
  before_filter :signed_in_user
  
  def index    
    if user_companies != [] 
      @company_id = user_companies.first.id
      @contractors = Contractor.where(company_id: @company_id)
    else
        @company_id =nil
        @contractors = []
    end      
  end
  
  def select_company
    @company_id = params[:company]
    if Company.where(id: @company_id, user_id: current_user.id) != []
      @contractors = Contractor.where(company_id: @company_id)      
    else
        @company_id =nil
        @contractors = []
    end    
    render 'index'
  end
  
  def show    
    if user_companies != []
      @contractor = current_user.contractors.find_by_id(params[:id])
      if @contractor == nil
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
      @contractor = current_user.contractors.find_by_id(params[:id])
      if @contractor == nil
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
      @contractor = Contractor.new
    end 
  end
  
  def create
    @contractor = Contractor.new(params[:contractor])    
    if Company.where(id: @contractor.company_id, user_id: current_user.id) != []
      if @contractor.save
        flash[:success] = "New contractor successfully added."
        redirect_to @contractor
      else
        render 'new'
      end
    else
      flash[:warning] = ACCESS_FAILURE_WARNING
      redirect_to action:'index'
    end
  end
  
  def update
    @contractor = current_user.contractors.find(params[:id])    
    if @contractor.update_attributes(params[:contractor])
      flash.now[:success] = "Contractor updated"
      render 'show'
    else
      render 'edit'
    end
  end
end

