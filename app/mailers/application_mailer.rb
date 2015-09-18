class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'

  def send_welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to MyFlix!"
  end
end