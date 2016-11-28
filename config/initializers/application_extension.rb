module ApplicationExtension
  extend ActiveSupport::Concern
  included do
    has_attached_file :icon, styles: { tiny: "100x100#", small: "250x250#", medium: "500x500#" }
    validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/

    has_attached_file :apns_certificate
    do_not_validate_attachment_file_type :apns_certificate

    has_attached_file :cloud_code_file
    do_not_validate_attachment_file_type :cloud_code_file

    after_create :add_subscription

    has_many :purchases
    has_many :capabilities
    has_many :services, through: :capabilities
    has_many :subscriptions, through: :purchases
    has_many :stats
    has_many :collaborations
    has_many :users, through: :collaborations
    has_many :teams
    has_many :alerts
    has_many :medical_devices

    has_one :parse_app, :dependent => :destroy

    def valid_purchase?
      if self.purchases.present? && self.purchases.last.expires_on.present? && self.purchases.last.expires_on.future?
        true
      else
        false
      end
    end

    def add_subscription
      subscription = Subscription.find_by(name: "DEV")
      if subscription.present?
        Purchase.create! application_id: self.id, subscription_id: subscription.id, expires_on: nil
      end
    end

    # Unique resource owners.
    def resource_owners
      Doorkeeper::AccessGrant.where(application_id: id).group_by(&:resource_owner_id)
    end
  end
end
