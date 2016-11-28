require 'interactor'

class ProductInteractor::FindExisting
  include Interactor
  
  def call
    context.product = Product.find_by_upc(context.upc)
  end

end
