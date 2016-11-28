# Persist Factual products given an array of factual search results.
class ProductInteractor::CreateFromResults

  include Interactor

  before do
    context.products ||= []
  end

  def call
    context.factual_products.each do |product|
      result = ProductInteractor::CreateFromFactual.call factual_product: product

      if result.success?
        context.products << result.product
      else
        context.status = result.status
        context.fail! message: result.message
      end
    end
  end

end
