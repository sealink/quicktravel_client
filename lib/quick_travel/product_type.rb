module QuickTravel
  class ProductType < Adapter
    self.api_base = '/api/product_types'

    def self.all
      QuickTravel::Cache.cache 'all_product_types' do
        super
      end
    end

    def route
      Route.first(id)
    end

    def routes
      Route.all(id)
    end
  end
end
