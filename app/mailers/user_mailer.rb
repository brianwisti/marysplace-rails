class UserMailer < ActionMailer::Base
  default from: "#{ENV['ADMIN_NAME']} <#{ENV['ADMIN_EMAIL']}>"

  # Hey, somebody requested a password reset for your account.
  def password_reset_notification user
    @user         = user
    token         = user.perishable_token
    @reset_url    = url_for controller: :password_resets, action: :edit, id: token, only_path: false
    @org_app_name = ENV['ADMIN_ORG_APP_NAME']
    @user_login   = user.login
    @subject      = "Password Reset Request Made For #{@user.login}"
    @sender_name  = ENV['ADMIN_NAME']
    @sender_email = ENV['ADMIN_EMAIL']
    recipient     = "#{user.login} <#{user.email}>"
    sender        = "#{@sender_name} <#{@sender_email}>"
    subject_line  = "[#{@org_app_name}] #{@subject}"

    mail to: recipient,
      subject:     subject_line,
      from:        sender,
      return_path: @sender_email
  end
end
