class ProductInteractor::FindProduct
  include Interactor

  def call
    if product.update context.to_h.slice(:type, :lat, :lon)
      context.product = product
    else
      context.status = :bad_request
      context.fail! message: product.errors.full_messages
    end
  end

  private

  def product
    Product.find_by_upc(context.upc)
  end

end