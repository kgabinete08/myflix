class PasswordResetsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user
      user.create_reset_token
      ApplicationMailer.send_password_reset(user).deliver
      redirect_to password_reset_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email field cannot be blank." : "Please check your email address."
      redirect_to forgot_password_path
    end
  end

  def edit
    @user = User.find_by(reset_token: params[:id])
    redirect_to expired_token_path unless @user
  end

  def update
    user = User.find_by(reset_token: params[:id])
    if user
      user.password = params[:user][:password]
      user.save
      flash[:success] = "Your password has been changed."
      user.clear_reset_token
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end
end