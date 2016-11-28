require 'ostruct'
require 'i18n'

# Contains a list of all devices supported by Nuwe, and their connectedness for the given user.
class AppList

  def initialize(user)
    @user = user
  end

  # The list for this specific user.
  # This list is exposed via the API.
  def list
    {
      apps: {
        nutrition:      category(:nutrition).map{|provider| OpenStruct.new(attributes(provider)).to_h},
        activity:       category(:activity).map{|provider| OpenStruct.new(attributes(provider)).to_h},
        biometric:      category(:biometric).map{|provider| OpenStruct.new(attributes(provider)).to_h}
      }
    }
  end

  # Master list of all apps supported by Nuwe.
  def self.apps
    {
      nutrition: %w(nutribu),
      activity: %w(withings moves fitbit humanapi),
      biometric: %w(withings humanapi)
    }
  end

  private

  # Ordered array of providers the user has connected.
  def connected(category)
    @user.apps.where(provider: self.class.send(:apps)[category]).order(:position).map&:provider
  end

  # Ordered, connected providers first, then unconnected providers after.
  def category(category)
    unconnected = self.class.send(:apps)[category] - connected(category)
    connected(category) + unconnected
  end

  # Return a hash with attributes specific for a provider.
  def attributes(provider)
    I18n.t("app_list.#{provider}").merge({
      connected: @user.apps.where(provider: provider).present?
    })
  end

end
