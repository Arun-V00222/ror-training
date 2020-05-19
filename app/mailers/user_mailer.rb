class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user.user_email, subject: 'Thanks for signing up')
  end
end
