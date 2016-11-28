require 'interactor'

module DoorkeeperInteractor
  class AddServices

    include Interactor

    def call
      service = Service.find_or_create_by(name: "Nuwe Ingredients")
      context[:application].capabilities.create!(service: service)
      service = Service.find_or_create_by(name: "Nuwe Meals")
      context[:application].capabilities.create!(service: service)
      service = Service.find_or_create_by(name: "Nuwe Security - Standard")
      context[:application].capabilities.create!(service: service)
      service = Service.find_or_create_by(name: "Nuscore")
      context[:application].capabilities.create!(service: service)
      service = Service.find_or_create_by(name: "Nuwe Nutrition")
      context[:application].capabilities.create!(service: service)
      service = Service.find_or_create_by(name: "Nuwe Teams")
      context[:application].capabilities.create!(service: service)
      service = Service.find_or_create_by(name: "Nuwe Wearables")
      context[:application].capabilities.create!(service: service)
    end

  end
end
