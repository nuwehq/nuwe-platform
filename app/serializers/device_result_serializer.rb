class DeviceResultSerializer < ActiveModel::Serializer
  attributes :id, :data, :created_at, :updated_at, :filename
end
