class CustomersController < ApplicationController  
  before_filter :signed_in_user
  
  def index    
    if user_companies != [] 
      @company_id = user_companies.first.id      
      @customers = Customer.where(company_id: @company_id)
    else
        @company_id =nil
        @customers = []
    end        
  end
  
  def select_company
    @company_id = params[:company]
    if Company.where(id: @company_id, user_id: current_user.id) != []
      @customers = Customer.where(company_id: @company_id)      
    else
        @company_id =nil
        @customers = []
    end    
    render 'index'
  end
  
  def show
    if user_companies != []
      @customer = current_user.customers.find_by_id(params[:id])
      if @customer == nil
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
      @customer = current_user.customers.find_by_id(params[:id])
      if @customer == nil
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
      @customer = Customer.new
    end
  end
  
  def create
    @customer = Customer.new(params[:customer])
    if Company.where(id: @customer.company_id, user_id: current_user.id) != []        
      if @customer.save
        flash[:success] = "New customer successfully added."
        redirect_to @customer
      else
        render 'new'
      end
    else
      flash[:warning] = ACCESS_FAILURE_WARNING
      redirect_to action:'index'
    end 
  end
  
  def update
    @customer = current_user.customers.find(params[:id])    
    if @customer.update_attributes(params[:customer])
      flash.now[:success] = "Customer updated"
      render 'show'
    else
      render 'edit'
    end
  end
end
