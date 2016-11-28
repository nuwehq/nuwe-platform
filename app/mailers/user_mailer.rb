class UserMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  def register_confirm(user)
    @user = user
    mail(to: @user.email, subject: 'Please confirm your account', from: from)
  end

  def reset_password(user, reset_password_url)
    @user = user
    @reset_password_url = reset_password_url
    mail(to: @user.email, subject: "Nuwe password reset", from: from)
  end

  def question_from_landing(theme, text)
    @theme = theme
    @text = text
    mail(to: ["tech@nuwe.co", "hello@nuwe.co"], subject: "Message from Landing page #{@theme}", from: "tech@nuwe.co")
  end

  private

  def from
    "Nuwe <hello@nuwe.co>"
  end

end
