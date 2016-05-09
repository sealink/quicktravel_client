require 'quick_travel/adapter'
require 'quick_travel/bed_requirement'
require 'quick_travel/passenger_price_break'
require 'quick_travel/product_type'

module QuickTravel
  class Resource < Adapter
    self.api_base = '/resources'

    def sub_resources
      Resource.find_all!('/resources.json', parent_resource_id: @id)
    end

    def self.all_with_price(opts)
      find_all!("/api/resources/index_with_price.json",
                opts.merge(cache: "#{name}.all_with_price-attrs?#{opts.to_param}&date=#{Date.current}"))
    end

    def product_type
      QuickTravel::ProductType.find(product_type_id)
    end

    def bed_requirements
      @_bed_requirements ||= Array.wrap(@bed_requirements).map do |bed_requirement|
        BedRequirement.new(bed_requirement)
      end
    end
  end
end
