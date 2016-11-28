module CollectionHelper
  def all_services
    Service.order(:name)
  end
end
