require 'quick_travel/init_from_hash'

module QuickTravel
  class BackgroundCheck
    include QuickTravel::InitFromHash

    def self.check(options = {})
      get_and_validate('/background_check/check.json', options)
    end
  end
end
