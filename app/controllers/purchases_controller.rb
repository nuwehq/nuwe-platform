class PurchasesController < ApplicationController
  protect_from_forgery except: :webhook
  before_action :find_application

  def new
    @purchase = Purchase.new
  end

  def create
    result = PurchaseInteractor::SetUp.call({
      subscription_id: params[:subscription_id],
      application_id: params[:application_id],
      stripeToken: params[:stripeToken],
      stripeEmail: params[:stripeEmail]
    })
    if result.success?
      redirect_to oauth_application_path(@application), notice: "A subscription has been purchased"
    else
      render "new"
    end
  end

  # This updates a purchases expires_on date when a purchase is renewed and webhook type of 'invoice.payment_succeeded' is received by the app.
  # Other webhook events can also be setup to trigger actions in the app.  Used ngrok to generate url to test these events locally.
  # POST /purchases/webhook
  def webhook
    # Retrieve the request's body and parse it as JSON
    event_json = JSON.parse(request.body.read)
    # Verify the event by fetching it from Stripe
    event = Stripe::Event.retrieve(event_json["id"])

    case event.type
      when "invoice.payment_succeeded" # renew subscription
        purchase = Purchase.find_by stripe_customer_token: event.data.object.customer
        purchase.update_attributes expires_on: Date.current + Subscription::DURATION
    end
    render status: :ok, json: "success"
  end
end
