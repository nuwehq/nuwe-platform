class PurchaseInteractor::SetUp

  include Interactor::Organizer

    before do
      context.subscription = Subscription.find context.subscription_id
    end

    organize [
      PurchaseInteractor::CreatePurchase,
      PurchaseInteractor::SubscribeStripeCustomer
    ]

end
