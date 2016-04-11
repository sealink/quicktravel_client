require 'quick_travel/adapter'

module QuickTravel
  class ProductType < Adapter
    self.api_base = '/api/product_types'
    self.lookup = true

    def routes
      Route.all(id)
    end

    def resource_categories
      ResourceCategory.all(product_type_ids: [id])
    end
  end
end
