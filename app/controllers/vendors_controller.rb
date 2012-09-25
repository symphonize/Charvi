class VendorsController < ApplicationController
  before_filter :signed_in_user
  
  def index 
    if user_companies != [] 
      @company_id = user_companies.first.id      
      @vendors = Vendor.where(company_id: @company_id)
    else
        @company_id =nil
        @vendors = []
    end
  end
  
  def select_company
    @company_id = params[:company]
    if Company.where(id: @company_id, user_id: current_user.id) != []
      @vendors = Vendor.where(company_id: @company_id)      
    else
        @company_id =nil
        @vendors = []
    end    
    render 'index'
  end
  
  def show
    if user_companies != []
      @vendor = current_user.vendors.find_by_id(params[:id])
      if @vendor == nil
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
      @vendor = current_user.vendors.find_by_id(params[:id])
      if @vendor == nil
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
      @vendor = Customer.new
    end
  end
  
  def create
    @vendor = Vendor.new(params[:vendor])
    @vendor.user_id = current_user.id
    if @vendor.save
      flash[:success] = "New vendor successfully added."
      redirect_to @vendor
    else
      render 'new'
    end
  end
  
  def update
    @vendor = Vendor.find(params[:id])
    @vendor.user_id = current_user.id
    if @vendor.update_attributes(params[:vendor])
      flash.now[:success] = "Vendor updated"
      render 'show'
    else
      render 'edit'
    end
  end
end

