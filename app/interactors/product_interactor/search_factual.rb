require 'interactor'
require 'factual'
require 'uri'

# Searches factual db, not local db, and return results.  Results saved in our db.
class ProductInteractor::SearchFactual

  include Interactor

  def call
    return if context.products.present?

    if factual_products.present?
      context.factual_products = factual_products
    else
      context.status = :not_found
      context.fail! message: ["Could not find any products containing #{context.name}"]
    end
  end

  private

    def factual
      Factual.new(context.remote_application_key, context.remote_application_secret)
    end

    def factual_products
      @factual_products = []
      factual.table("products-cpg-nutrition").filters("product_name" => {"$search" => context.name}).page(context.page).rows.each do |row|
        @factual_products << row
      end
      @factual_products
    end

end
