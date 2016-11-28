class DeveloperSignup

  include Interactor

  def call
    user = User.new context.params
    user.roles << 'developer'

    if user.save
      user.oauth_applications.create! name: "Sample app", description: "Add your App description here", redirect_uri: "urn:ietf:wg:oauth:2.0:oob"
      context.user = user
    else
      context.fail! user: user, message: user.errors.full_messages
    end
  end

end
