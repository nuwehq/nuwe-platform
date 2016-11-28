class DataQueryInteractor::Setup
  include Interactor::Organizer

  organize [
    DataQueryInteractor::GateKeeper,
    DataQueryInteractor::FindFirst,
    DataQueryInteractor::FindLast,
    DataQueryInteractor::FindDate,
    DataQueryInteractor::FindDateRange,
    DataQueryInteractor::FindFilename,
    DataQueryInteractor::FindMedicalDevices
  ]

end
