class CustomersController < ApplicationController  
  before_filter :signed_in_user
  
  def index    
    @company_id = Company.first.id      
    @customers = Customer.where(company_id: @company_id)      
  end
  
  def select_company
    @company_id = params[:company]
    @customers = Customer.where(company_id: @company_id)
    render 'index'
  end
  
  def show
    @customer = Customer.find(params[:id])
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end

  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.new(params[:customer])
    if @customer.save
      flash[:success] = "New customer successfully added."
      redirect_to @customer
    else
      render 'new'
    end
  end
  
  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(params[:customer])
      flash.now[:success] = "Customer updated"
      render 'show'
    else
      render 'edit'
    end
  end
end
