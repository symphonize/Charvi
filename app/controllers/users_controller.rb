class UsersController < ApplicationController
   before_filter :signed_in_user, only: [:index, :edit, :update, :create, :show, :new]
   before_filter :correct_user,   only: [:edit, :update]
   
  def show
    if is_admin?
      @user = User.find(params[:id])
    elsif is_owner?
      @user = User.find_by_id_and_company_token(params[:id], company_token)
    else
      @user = current_user  
    end    
  end
  
  def new
    if(is_admin? || is_owner?)
      @user = User.new
    else
      redirect_to root_url
    end
    
  end
  
  def index
    if is_admin?
      @users = User.paginate(page: params[:page])
    elsif is_owner?
      @users = User.where("role != 'Admin'").paginate(page: params[:page])
    else
      @users = User.where(id: current_user.id).paginate(page: params[:page])     
    end
  end
  
  def edit
    if(is_admin?)
      @user = User.find_by_id(params[:id])
    elsif(is_owner?)
      @user = User.find_by_id_and_company_token(params[:id], company_token)
    else
      @user = current_user            
    end  
    if @user == nil
      flash[:warning] = ACCESS_FAILURE_WARNING
      redirect_to action:'index'  
    end
  end
  
  def create
    if(is_admin? || is_owner?)
      @user = User.new(params[:user])    
      @user[:role] = "Owner" 
      @user[:company_token] = company_token
      if @user.save
        flash[:success] = "New user successfully created"
        redirect_to @user
      else
        render 'new'
      end
    else
      redirect_to root_url
    end
  end
  
  def update    
    if(is_admin?)
      @user = User.find_by_id(params[:id])
    elsif(is_owner?)
      @user = User.find_by_id_and_company_token(params[:id], company_token)
    else
      @user = current_user            
    end
    if(@user != nil)      
      user_attributes = params[:user]
      if(params[:source] == "password")
        user_attributes[:name] = @user.name
        user_attributes[:email] = @user.email
        user_attributes[:role] = @user.role          
      end  
      if @user.update_attributes(user_attributes)
        flash.now[:success] = "User information updated"
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
