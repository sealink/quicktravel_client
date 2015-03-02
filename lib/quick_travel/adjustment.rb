require 'quick_travel/adapter'

module QuickTravel
  class Adjustment < Adapter
    attr_accessor :id, :description, :gross_in_cents
    money :gross
  end
end
