class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      ApplicationMailer.delay.send_invitation_email(@invitation)
      flash[:success] = "Your invitation has been sent!"
      redirect_to new_invitation_path
    else
      flash.now[:danger] = "All fields must be completed."
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end