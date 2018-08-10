module QuickTravel
  class ResourceGroup
    include QuickTravel::InitFromHash

    def product_type
      ProductType.find(product_type_id)
    end
  end
end
