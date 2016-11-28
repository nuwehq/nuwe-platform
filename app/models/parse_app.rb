class ParseApp < ActiveRecord::Base
  before_create :generate_keys
  before_create :generate_port

  belongs_to :application, class_name: 'Doorkeeper::Application'
  validates_uniqueness_of :port

  def generate_port
    if ParseApp.last.present?
      puts ParseApp.last.port
      last_parse = ParseApp.last
      self.port = last_parse.port + 1
    else
      81
    end
  end

  def generate_keys
    self.app_id = SecureRandom.hex(16)
    self.master_key = SecureRandom.hex(16)
    self.client_key = SecureRandom.hex(16)
  end


end
