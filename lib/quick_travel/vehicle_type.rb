require 'quick_travel/adapter'

module QuickTravel
  class VehicleType < Adapter
    attr_accessor :id, :name, :position, :code, :default_weight, :description, :detail_prompt, :double_length, :fixed_length, :fixed_weight
    attr_accessor :has_cargo,	:default, :maximum_length, :minimum_length, :trailer

    self.api_base = '/vehicle_types'
    self.lookup = true
  end
end
