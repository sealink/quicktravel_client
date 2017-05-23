require 'quick_travel/adapter'

module QuickTravel
  class Setting < Adapter
    def self.basic
      find_all!("/api/settings/basic.json").first
    end
  end
end
