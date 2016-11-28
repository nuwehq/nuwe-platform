class UserMailerPreview < ActionMailer::Preview

  def register_confirm
    UserMailer.register_confirm(User.first)
  end

  def reset_password
    UserMailer.reset_password(User.first, "http://nuapi.dev/reset-password")
  end

end
