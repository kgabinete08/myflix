class AdminsController < ApplicationController
  before_filter :require_admin

  private

  def require_admin
    if !current_user.admin?
      flash[:danger] = "Authorized users only."
      redirect_to home_path
    end
  end
end
