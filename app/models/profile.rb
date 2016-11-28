# Stores all the fields in the secondary screen of the app.
# These are not needed to login.
class Profile < ActiveRecord::Base

  belongs_to :user, :dependent => :destroy

  validates_uniqueness_of :facebook_id, allow_nil: true
  validates :activity, inclusion: 1..5

  delegate :weight=, :height=, :bpm=, :blood_pressure=, to: :user

  has_attached_file :avatar, styles: { tiny: "100x100#", small: "250x250#", medium: "500x500#" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # Allow preferences to be easily set via the API,
  # but use the Preference model to store it neatly.
  %w(units use_health_data).each do |preference|
    define_method "#{preference}=" do |value|
      user.preferences.where(name: preference).destroy_all
      user.preferences.create! name: preference, value: value
    end
  end

end
