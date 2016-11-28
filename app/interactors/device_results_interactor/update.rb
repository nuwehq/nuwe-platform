class DeviceResultsInteractor::Update
  include Interactor::Organizer

  organize [
    DeviceResultsInteractor::UpdateDeviceResults,
    DeviceResultsInteractor::UpdateColumns
  ]

end
