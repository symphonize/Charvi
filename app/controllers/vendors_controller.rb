class VendorsController < ApplicationController
  before_filter :signed_in_super_user
  
  def index 
    if company_token != nil
      @vendors = Vendor.where(company_token: @company_token)
    else
        @vendors = []
    end
  end
  
  def show
    if company_token != nil
      @vendor = Vendor.find_by_id_and_company_token(params[:id], company_token)
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
    if company_token != nil
      @vendor = Vendor.find_by_id_and_company_token(params[:id], company_token)
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
    if(company_token == nil)
      flash[:warning] = NO_COMPANIES_WARNING
      redirect_to action:'index'
    else
      @vendor = Customer.new
    end
  end
  
  def create
    @vendor = Vendor.new(params[:vendor])  
    @vendor[:company_token] = company_token
      if @vendor.save
        flash[:success] = "New vendor successfully added."
        redirect_to @vendor
      else
        render 'new'
      end
  end
  
  def update
    @vendor = Vendor.find_by_id_and_company_token(params[:id], company_token)    
    if @vendor.update_attributes(params[:vendor])
      flash.now[:success] = "Vendor updated"
      render 'show'
    else
      render 'edit'
    end
  end
end

