require 'quick_travel/adapter'

module QuickTravel
  class ResourceCategory < Adapter
    self.api_base = '/api/resource_categories'
    self.lookup = true

    def product_type
      QuickTravel::ProductType.find(product_type_id)
    end
 end
end
