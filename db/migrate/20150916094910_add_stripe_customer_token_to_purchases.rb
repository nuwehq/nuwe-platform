class AddStripeCustomerTokenToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :stripe_customer_token, :string
  end
end
