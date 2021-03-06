require 'rubygems'
#require 'smtp_tls'
require 'net/smtp'
# User emails handler class
class UserMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'

  # Sends an activation email to the user
  #
  # @param user {User}, to send email to
  def activation_needed_email(user)
      @user = user
      @url = coursewareable.activate_user_url(@user.activation_token)
      msg = "Subject: Hi There!\n\nThis works, and this part is in the body. Click on the 
      following link to activate your account" + @url
      smtp = Net::SMTP.new 'smtp.gmail.com', 587
      smtp.enable_starttls
      smtp.start("YourDomain", "learnwithlliks@gmail.com", "getstarted", :login) do
      smtp.send_message(msg, "learnwithlliks@gmail.com", @user.email)
    end
    #@user = user
    #@url = coursewareable.activate_user_url(@user.activation_token)
    #mail(:to => @user.email, :subject => _('Welcome to Courseware'))
  end

  # Sends an activation confirmation email to the user
  #
  # @param user {User}, to send email to
  def activation_success_email(user)
    @user = user
    @url = coursewareable.login_url
    mail(
      :to => user.email,
      :subject => _('Your Courseware account was activated')
    )
  end

  # Sends a reset password email to the user
  #
  # @param user {User}, to send email to
  def reset_password_email(user)
    @user = user
    @url = coursewareable.edit_password_url(@user.reset_password_token)
    mail(
      :to => user.email,
      :subject => _('Your Courseware password has been reset')
    )
  end

end
