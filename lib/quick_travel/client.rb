# frozen_string_literal: true

require 'quick_travel/adapter'
require 'quick_travel/init_from_hash'

module QuickTravel
  class Client < Adapter
    include QuickTravel::InitFromHash
    self.api_base = '/api/clients'

    def templates
      get_and_validate("/api/clients/#{id}/templates")
    end
  end
end
