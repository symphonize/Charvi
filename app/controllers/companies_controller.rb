class CompaniesController < ApplicationController
  before_filter :signed_in_user
  def index
    @companies = current_user.companies.all  
  end
  
  def show
    @company = current_user.companies.find(params[:id])
  end
  
  def edit
    @company = current_user.companies.find(params[:id])
  end

  def new
    @company = Company.new
  end
  
  def create
    @company = Company.new(params[:company])
    @company.user_id = current_user.id
    if @company.save
      flash[:success] = "New company successfully added."
      redirect_to @company
    else
      render 'new'
    end
  end
  
  def update
    @company = current_user.companies.find(params[:id])
    @company.user_id = current_user.id
    if @company.update_attributes(params[:company])
      flash.now[:success] = "Company updated"
      render 'show'
    else
      render 'edit'
    end
  end
end
