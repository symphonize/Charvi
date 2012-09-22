class CompaniesController < ApplicationController
  before_filter :signed_in_user
  def index
    @companies = Company.all  
  end
  
  def show
    @company = Company.find(params[:id])
  end
  
  def edit
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end
  
  def create
    @company = Company.new(params[:company])
    if @company.save
      flash[:success] = "New company successfully added."
      redirect_to @company
    else
      render 'new'
    end
  end
  
  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(params[:company])
      flash.now[:success] = "Company updated"
      render 'show'
    else
      render 'edit'
    end
  end
  
  
end
