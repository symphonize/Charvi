class CompaniesController < ApplicationController
  before_filter :signed_in_super_user, only: [:index, :edit, :update, :show]
  def index
    if(is_owner?)
      @companies = Company.where(company_token: company_token)
    elsif(is_admin?)
      @companies = Company.all
    end
  end
  
  def show
    if(is_owner?)
      @company = Company.find_by_company_token(company_token)
    elsif(is_admin?)
      @company = Company.find(params[:id])
    end
  end
  
  def edit
    if(is_owner?)
      @company = Company.find_by_company_token(company_token)
    elsif(is_admin?)
      @company = Company.find(params[:id])
    end    
  end

  def new
    @company = Company.new
    @company.users.build
  end
  
  def create
    @company = Company.new(params[:company])
    uuid = SecureRandom.uuid
    @company[:company_token] = uuid    
    if @company.save
      new_user = User.where("company_token = '" + uuid +"'").first
      sign_in new_user
      flash[:success] = "Welcome to BYT!"
      redirect_to new_user
    else
      render 'new'
    end
  end
  
  def update
     if(is_owner?)
      @company = Company.find_by_company_token(company_token)
    elsif(is_admin?)
      @company = Company.find(params[:id])
    end
    if(@company != nil)
      if @company.update_attributes(params[:company])
        flash.now[:success] = "Company updated"
        render 'show'
      else
        render 'edit'
      end
    else
      flash[:warning] = ACCESS_FAILURE_WARNING
      redirect_to action:'index'
    end
  end
end
