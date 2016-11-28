class MedicalDevice < ActiveRecord::Base
  before_create :generate_token

  belongs_to :application, class_name: 'Doorkeeper::Application'
  has_many :device_results
  has_many :column_values
  has_many :device_files

  private

  def generate_token
    self.token = SecureRandom.uuid
  end

end
