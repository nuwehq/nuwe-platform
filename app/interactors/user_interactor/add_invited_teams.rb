require 'interactor'

module UserInteractor
  class AddInvitedTeams
    include Interactor

    def call
      Invitation.where(email: context.user.email).find_each do |invitation|
        Membership.create! user_id: context.user.id, team_id: invitation.team.id
      end
    end

  end
end
