require 'interactor'

class ProductInteractor::SearchProducts
  include Interactor::Organizer

  before do
    context.page ||= '1'
    unless context.page.in? %w{1 2 3 4 5}
      context.status = :bad_request
      context.fail! message: ["Page requested is outside of the acceptable range of 1 - 5.  Please try again."]
    end
  end

  organize [
    ProductInteractor::CheckCredentials,
    ProductInteractor::SearchFactual,
    ProductInteractor::CreateFromResults
  ]

end
