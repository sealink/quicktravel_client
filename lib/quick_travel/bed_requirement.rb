require 'quick_travel/adapter'

module QuickTravel
  class BedRequirement < Adapter
    attr_accessor :id, :name, :single_bed_count, :double_bed_count
  end
end
