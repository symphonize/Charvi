class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  protected

    def signed_in_user
       unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
        end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
  
end
