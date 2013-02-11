class ContractorsController < ApplicationController
  before_filter :signed_in_super_user
  
  def index    
    if company_token != nil
      @contractors = Contractor.where(company_token: company_token)
    else
        @contractors = []
    end      
  end
  
  def show
      @contractor = Contractor.find_by_id_and_company_token(params[:id], company_token)
      if @contractor == nil
        flash[:warning] = ACCESS_FAILURE_WARNING
        redirect_to action:'index'  
      end
  end
  
  def edit
    if company_token != nil
      @contractor = Contractor.find_by_id_and_company_token(params[:id], company_token)
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
      @contractor = Contractor.new
      @contractor.users.build
  end
  
  def create
    @contractor = Contractor.new(params[:contractor])   
    @contractor[:company_token] = company_token
    params[:contractor][:user][:company_token] = company_token
    @contractor[:email] = params[:contractor][:user][:email]
    if @contractor.save
      flash[:success] = "New contractor successfully added."
      redirect_to @contractor
    else
      render 'new'
    end
  end
  
  def update
    @contractor = Contractor.find_by_id_and_company_token(params[:id], company_token)   
    if @contractor.update_attributes(params[:contractor])
      flash.now[:success] = "Contractor updated"
      render 'show'
    else
      render 'edit'
    end
  end
end

