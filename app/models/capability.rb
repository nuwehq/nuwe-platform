class Capability < ActiveRecord::Base

  belongs_to :application, class_name: 'Doorkeeper::Application'
  belongs_to :service

end
