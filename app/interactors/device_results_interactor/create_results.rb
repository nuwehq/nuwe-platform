class DeviceResultsInteractor::CreateResults
  include Interactor

  before do
    context.device_results = []
  end

  delegate :medical_device, to: :context

  def call
    context.data.each do |row|
      context.device_result = medical_device.device_results.new data: row
      context.device_result.save!
      context.device_results << context.device_result
    end
    context.status = :created
  rescue => error
    context.status = :bad_request
    context.fail! message: error.message
  end
end
