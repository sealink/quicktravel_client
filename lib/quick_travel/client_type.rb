module QuickTravel
  class ClientType < Adapter
    attr_accessor :id, :name, :agent, :position, :right_id
    self.api_base = '/client_types'
  end
end
