require 'active_support/concern'

module Nu
  # Provides methods to ActiveRecord models in the host app.
  module Model
    extend ActiveSupport::Concern

    included do
      has_many :nu_biometrics, class_name: "Nu::Biometric"
      has_many :nu_activities, class_name: "Nu::Activity"
      has_many :nu_nutritions, class_name: "Nu::Nutrition"
    end

  end
end
