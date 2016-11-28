require 'interactor'

class ProductInteractor::CheckCredentials

  include Interactor

  def call
    if context.application.nil?
      context.remote_application_key = ENV['FACTUAL_KEY']
      context.remote_application_secret = ENV['FACTUAL_SECRET']
    else
      service = context.application.services.where(lib_name: "factual_upc").first
      capability = context.application.capabilities.where(service_id: service.id).first
      context.remote_application_key = capability.remote_application_key
      context.remote_application_secret = capability.remote_application_secret
    end

    context.fail! message: "Remote application key is required" if context.remote_application_key.blank?
    context.fail! message: "Remote application secret is required" if context.remote_application_secret.blank?
  end

end
