require 'factual'
require 'uri'

# Look up places of interest for given coordinates.
# Parameters should contain lat, lon and radius (in meters)
class FetchPlaces
  include Interactor

  # Allowed categories from Factual
  # http://developer.factual.com/working-with-categories/
  # including a mid-level caotegory will implicitly include all nested categries 
  ALLOWED_CATEGORIES = [
    149, 150, 151, 152, 153, 154, 155, 156, 
    443, 169, 171, 230, 231, 232, 312, 313, 
    314, 315, 316, 319, 320, 321, 322, 323, 
    324, 325, 326, 327, 328, 329, 330, 331, 
    332, 333, 334, 335, 463, 338, 369, 370, 
    430]

  before do
    context.radius ||= 5000

    context.fail! message: ["A <lat> parameter is required"] unless context[:lat].present?
    context.fail! message: ["A <lon> parameter is required"] unless context[:lon].present?
  end

  # find and return top 10 places
  def call
    raw_data = factual.table("places").filters("category_ids" => {"$includes_any" => ALLOWED_CATEGORIES}).geo("$circle" => {"$center" => [context.lat, context.lon],"$meters" => context.radius.to_i}).data[0..9]

    if raw_data.present?
      context.data = raw_data
    else
      context.status = :not_found
      context.fail! message: ["Unable to find anything within #{context.radius}m of your coordinates"]
    end
  end

  private

  def factual
    Factual.new(ENV['FACTUAL_KEY'], ENV['FACTUAL_SECRET'])
  end
end
