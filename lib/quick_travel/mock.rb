module QuickTravel
  class Resource
    def self.find(id)
      new(id: id)
    end

    def product_type
      QuickTravel::ProductType.new
    end
  end

  class ProductType
    def needs_passengers
      return true if @needs_passengers.nil?
      @needs_passengers
    end
  end

  class PassengerType
    def self.all
      [
        PassengerType.new(id: 1, name: 'Adult'),
        PassengerType.new(id: 2, name: 'Child')
      ]
    end
  end

  class Adapter
    def self.all
      [new, new]
    end
  end

  class PropertyType < Adapter
    def self.all
      [new, new]
    end
  end
  class Location < Adapter; end
  class Region < Adapter; end
end
