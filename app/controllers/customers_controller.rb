class CustomersController < ApplicationController  
  before_filter :signed_in_super_user
  
  def index    
    if company_token != nil
      @customers = Customer.where(company_token: company_token)
    else
        @customers = []
    end        
  end
  
  def show
    if company_token != nil
      @customer = Customer.find_by_id_and_company_token(params[:id], company_token)
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
    if company_token != nil
      @customer = Customer.find_by_id_and_company_token(params[:id], company_token)
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
    if(company_token == nil)
      flash[:warning] = NO_COMPANIES_WARNING
      redirect_to action:'index'
    else
      @customer = Customer.new
    end
  end
  
  def create
    @customer = Customer.new(params[:customer])
    @customer[:company_token] = company_token
    if @customer.save
      flash[:success] = "New customer successfully added."
      redirect_to @customer
    else
      render 'new'
    end
  end
  
  def update
    @customer = Customer.find_by_id_and_company_token(params[:id], company_token)
    if @customer.update_attributes(params[:customer])
      flash.now[:success] = "Customer updated"
      render 'show'
    else
      render 'edit'
    end
  end
end
