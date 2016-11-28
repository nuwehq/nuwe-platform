class DeviceResultsInteractor::ResultsSetUp
  include Interactor::Organizer

  organize [
    DeviceResultsInteractor::CreateResults,
    DeviceResultsInteractor::CreateColumns,
    DeviceResultsInteractor::AddMissingColumnKey
  ]

end
