# Mixin for methods dealing with apps.
module HasApps

  # Returns the first app for the given provider.
  def has_app(provider)
    apps.find_by(provider: provider)
  end

end
