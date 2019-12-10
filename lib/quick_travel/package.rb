require 'quick_travel/adapter'

module QuickTravel
  class Package < Adapter
    attr_reader :error_message

    self.api_base = '/api/packages'
    def product_type_id
      '554881941'
    end

    def product_type
      QuickTravel::ProductType.find(product_type_id)
    end
  end
end
