# Sign in an existing user using email and password.
class SignIn
  include Interactor

  before do
    if context.email.blank?
      context.status = :bad_request
      context.fail! message: ["Email must be present"]
    end

    if context.password.blank?
      context.status = :bad_request
      context.fail! message: ["Password must be present"]
    end
  end

  def call
    if user.authenticate context.password
      context.user_id = user.id
      context.user = user
      context.status = :ok
      Rails.logger.info "[#{context[:email]}] authenticated using has_secure_password"
    # try if the user came from the old system, Nutribu v1
    elsif user.md5_password == Digest::MD5.hexdigest(context.password)
      context.user_id = user.id
      context.user = user
      convert_md5_to_bcrypt! context.password
      context.status = :ok
      Rails.logger.info "[#{context[:email]}] authenticated using MD5"
    else
      context.status = :unauthorized
      context.fail! message: ["The password you have provided is not valid"]
    end
  end

  def token
    @token ||= user.tokens.first_or_create.id
  end

  private

  def user
    @user ||= User.find_by_email! context.email
  end

  def convert_md5_to_bcrypt!(password)
    user.password = user.password_confirmation = password
    user.md5_password = nil
    user.save!
    Rails.logger.info "[#{user.email}] password converted from md5 to bcrypt"
  end
end
