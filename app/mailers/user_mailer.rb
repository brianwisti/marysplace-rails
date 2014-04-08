class UserMailer < ActionMailer::Base
  default from: ENV['MANDRILL_USERNAME']

  def password_reset_email user
    @user = user
    token = user.perishable_token
    @reset_url = edit_password_resets_url token
    @org_app_name = "Mary's Place"
    @user_login = user.login
    @subject = "Password Reset Request Made For #{@user.login}"
    @sender_name = "Brian Wisti"
    @sender_email = "brian.wisti@gmail.com"
    subject_line = "[#{org_app_name}] #{@subject}"

    mail to: user.email, subject: subject_line
  end
end
