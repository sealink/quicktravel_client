require 'quick_travel/adapter'

module QuickTravel
  class ProductType < Adapter
    self.api_base = '/api/product_types'
    self.lookup = true

    def route
      Route.first(id)
    end

    def routes
      Route.all(id)
    end
  end
end
