class DataQueryInteractor::GateKeeper
  include Interactor

  before do
    context.search_results = []
  end

  def call
    return unless context.query.present?
    context.query.each do |k,v|
      if k == "first" && v == "true"
        context.find_first = [true]
      elsif k == "last" && v == "true"
        context.find_last = [true]
      elsif k == "date"
        context.find_date = [true]
      elsif k == "date_range"
        context.find_date_range = [true]
      elsif k == "filename"
        context.find_filename = [true]
      elsif context.query.include?("medical_devices")
        context.find_medical_devices = [true]
      else
        context.status = :bad_request
        context.fail! message: "Query request is not correct"
      end
    end
  end


end
