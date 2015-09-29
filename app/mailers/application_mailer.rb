class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'

  def send_welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to MyFlix!"
  end

  def send_password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, subject: "Join MyFlix!"
  end
end