class PurchaseInteractor::CreatePurchase

  include Interactor

  def call
    purchase = subscription.purchases.new
    purchase.price = context.subscription.price
    purchase.application = application
    purchase.expires_on = Date.current + Subscription::DURATION

    if purchase.save
      context.purchase = purchase
    else
      context.purchase = purchase
      context.fail! message: purchase.errors.full_messages
    end
  end

  def rollback
    context.purchase.destroy
  end

  private

  def subscription
    @subscription ||= context.subscription
  end

  def application
    @application ||= Doorkeeper::Application.find context.application_id
  end

end
