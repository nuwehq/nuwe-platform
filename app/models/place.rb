class Place < ActiveRecord::Base

  belongs_to :placeable, polymorphic: true

  validates_presence_of :name, :lat, :lon
end
