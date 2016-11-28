class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :lat, :lon
end