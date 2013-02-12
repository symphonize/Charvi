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
      if(params[:param] == "newuser")
        @contractor.users.build
        @users = nil
      else
        @contractor.users.build
        @users = User.where(company_token: company_token, contractor_id: nil)
      end
  end
  
  def create
    @contractor = Contractor.new(params[:contractor])   
    @contractor[:company_token] = company_token    
    contractor_user = User.find_by_id_and_company_token(params[:user_id], company_token)
    if(contractor_user == nil)
      if(params[:contractor][:user] == nil)
        flash.now[:error] = "User required."
        @users = User.where(company_token: company_token, contractor_id: nil)
        render 'new'
      else        
        @contractor[:email] = params[:contractor][:user][:email]
        if @contractor.save          
            flash[:success] = "New contractor successfully added."
            redirect_to @contractor
        else
          render 'new'
        end
      end
    else
      @contractor[:email] = contractor_user.email
      if @contractor.save
        if contractor_user.update_attribute("contractor_id", @contractor.id)
          flash[:success] = "New contractor successfully added."
          redirect_to @contractor
        else
          render 'new'    
        end
      else
        render 'new'
      end
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

