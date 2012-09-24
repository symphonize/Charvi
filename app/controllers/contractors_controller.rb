class ContractorsController < ApplicationController
  before_filter :signed_in_user
  
  def index    
    @company_id = Company.first.id      
    @contractors = Contractor.where(company_id: @company_id)      
  end
  
  def select_company
    @company_id = params[:company]
    @contractors = Contractor.where(company_id: @company_id)
    render 'index'
  end
  
  def show
    @contractor = Contractor.find(params[:id])
  end
  
  def edit
    @contractor = Contractor.find(params[:id])
  end

  def new
    @contractor = Contractor.new
  end
  
  def create
    @contractor = Contractor.new(params[:contractor])
    if @contractor.save
      flash[:success] = "New contractor successfully added."
      redirect_to @contractor
    else
      render 'new'
    end
  end
  
  def update
    @contractor = Contractor.find(params[:id])
    if @contractor.update_attributes(params[:contractor])
      flash.now[:success] = "Contractor updated"
      render 'show'
    else
      render 'edit'
    end
  end
end

