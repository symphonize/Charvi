module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    session[:company_token] = user.company_token
    self.current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def is_admin?
    current_user[:role] == "Admin"
  end
  
  def is_owner?
    current_user[:role] == "Owner"
  end
  
  def current_user=(user)
    @current_user = user
  end
  
   def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
    def company_token    
    session[:company_token]
  end
  
  def user_roles
    [
      ['Contractor', 'Contractor'],
      ['Owner', 'Owner']
    ]
  end
end
