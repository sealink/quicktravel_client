require 'quick_travel/adapter'

module QuickTravel
  class BackgroundCheck < Adapter
    def self.check(options = {})
      get_and_validate('/background_check/check.json', options)
    end
  end
end
