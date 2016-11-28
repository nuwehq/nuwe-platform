require 'pusher'

# Simple wrapper to send a Pusher message asynchronously.
class PusherWorker
  include Sidekiq::Worker

  # Parameters:
  # * channel_name:: required
  # * event_name:: required
  # * options:: Hash with options (optional)
  def perform(channel_name, event_name, options={})
    Pusher.trigger channel_name, event_name, options
  end

end
