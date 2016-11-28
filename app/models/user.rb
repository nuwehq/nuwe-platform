class User < ActiveRecord::Base

  include Measurement::Model
  include Nu::Model
  include HasApps

  before_create :build_profile

  has_secure_password

  validates_presence_of :email
  validates_uniqueness_of :email

  has_one :profile
  has_many :tokens
  has_many :apps
  has_many :meals
  has_many :preferences
  has_many :favourites

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner
  has_many :collaborations
  has_many :collaborated_applications, through: :collaborations, :source => :application

  has_many :eats, -> { order(created_at: :desc) }
  has_many :memberships
  has_many :teams, through: :memberships

  has_many :historical_scores, as: :history

  has_many :devices
  
  has_many :breakdowns, class_name: "Nutrition::Breakdown"

  delegate :first_name, :last_name, :sex, :birth_date, :activity, :facebook_id, :avatar, to: :profile

  # http://stackoverflow.com/questions/819263/get-persons-age-in-ruby
  def age
    return if birth_date.nil?

    today = Date.current
    today.year - birth_date.year - ((today.month > birth_date.month || (today.month == birth_date.month && today.day >= birth_date.day)) ? 0 : 1)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def token
    verifier.generate [id, Time.current]
  end

  def verify_token!(token)
    id, time = verifier.verify(token)
    time > 1.day.ago && id == self.id
  end

  def humanapi_public_token
    human_app = apps.where(provider: "humanapi").first
    human_app.credentials["publicToken"] if human_app
  end

  class << self
    def verifier_for(purpose)
      @verifiers ||= {}
      @verifiers.fetch(purpose) do |p|
        @verifiers[p] = Rails.application.message_verifier("#{self.name}-#{p.to_s}")
      end
    end
  end
  
  def confirm_email_token
    verifier = self.class.verifier_for('confirm-email') # Unique for each type of messages
    verifier.generate(email)
  end
  
  def confirm_email!(token)
    user_email = self.class.verifier_for('confirm-email').verify(token)
    if user_email == email
      update_attribute(:confirmed_at, Time.zone.now)
    end
    user_email == email
  end
  
  private

  def verifier
    Rails.application.message_verifier(:user)
  end
  
end
