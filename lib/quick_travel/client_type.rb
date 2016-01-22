require 'quick_travel/adapter'

module QuickTravel
  class ClientType < Adapter
    self.api_base = '/client_types'
  end
end
