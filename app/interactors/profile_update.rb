require 'interactor'

class ProfileUpdate

  include Interactor::Organizer

  before do
    context.profile = context.user.profile || context.user.create_profile
  end

  organize UpdateProfileFromAttributes, UpdateData, CalculateMissingDcn, DailyScores, PushHealthDataUpdated

end
