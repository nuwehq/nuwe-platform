require 'stripe'

class PurchaseInteractor::SubscribeStripeCustomer

  include Interactor

  def call
    return unless context.stripeToken

    # Create the customer in Stripe for recurring subscription charges
    context.customer = Stripe::Customer.create(
      email: context.stripeEmail,
      source: context.stripeToken,
      # For now, plan field matches the subscription name downcased.  WIP, but we can add a plan_id field to the table and ref that instead.
      # Plan is absolutely necessary to set up the the subscription plan!
      plan: context.subscription.name.downcase,
      metadata: {
        application_id: context.application_id,
        amount: context.purchase.price,
        currency: 'usd',
        description: context.subscription.name
      }
    )

    context.purchase.update_attributes stripe_customer_token: context.customer.id

    rescue Stripe::CardError => error
      context.fail! message: error.message
  end
end
