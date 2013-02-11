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
    
    def signed_in_super_user
       unless signed_in? && (is_admin? || is_owner?)
        store_location
        redirect_to signin_url, notice: "Please sign in."
        end
    end
    
    def signed_in_power_user
      unless signed_in? && (is_admin? || is_owner? || is_manager)
        store_location
        redirect_to signin_url, notice: "Please sign in."
        end
    end
    
    def correct_user
      if(!is_admin? && !is_owner?)
        @user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(@user)
      end
    end
  
end
