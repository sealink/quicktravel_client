# frozen_string_literal: true

require 'quick_travel/adapter'

module QuickTravel
  class ClientTemplates < Adapter
    self.api_base = '/api/client_templates'
  end
end
