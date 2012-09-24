class VendorsController < ApplicationController
  before_filter :signed_in_user
  
  def index    
    @company_id = Company.first.id      
    @vendors = Vendor.where(company_id: @company_id)      
  end
  
  def select_company
    @company_id = params[:company]
    @vendors = Vendor.where(company_id: @company_id)
    render 'index'
  end
  
  def show
    @vendor = Vendor.find(params[:id])
  end
  
  def edit
    @vendor = Vendor.find(params[:id])
  end

  def new
    @vendor = Vendor.new
  end
  
  def create
    @vendor = Vendor.new(params[:vendor])
    if @vendor.save
      flash[:success] = "New vendor successfully added."
      redirect_to @vendor
    else
      render 'new'
    end
  end
  
  def update
    @vendor = Vendor.find(params[:id])
    if @vendor.update_attributes(params[:vendor])
      flash.now[:success] = "Vendor updated"
      render 'show'
    else
      render 'edit'
    end
  end
end

