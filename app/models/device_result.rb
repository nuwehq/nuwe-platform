# Stores imported parsed data from a client app for a BluSense medical device
class DeviceResult < ActiveRecord::Base

  self.inheritance_column = nil # because we have a column "data"

  belongs_to :medical_device
  serialize :data
  before_create :create_date

  private

  def create_date
    unless self.date.present?
      self.date = Date.today
    end
  end

end
