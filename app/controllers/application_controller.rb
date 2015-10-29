class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_user
    redirect_to sign_in_path unless current_user
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def require_admin
    if !current_user.admin?
      flash[:danger] = "Authorized users only."
      redirect_to home_path
    end
  end

  helper_method :current_user
end
