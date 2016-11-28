require 'user'

# Update or create a User from the omniauth params
class UserFromOmniauth

  attr_reader :user

  def initialize(auth)
    @user = User.find_or_create_by(email: auth.info.email) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.email = auth["info"]["email"]
      user.name = auth["info"]["name"]
      unless user.password.present?
        password = SecureRandom.hex(8)
        user.password = password
        user.password_confirmation = password
      end
      user.save!
    end
  end
end