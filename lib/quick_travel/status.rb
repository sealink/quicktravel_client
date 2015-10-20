module QuickTravel
  class Status
    def self.check!
      # Test Cache
      QuickTravel::Cache.clear
      QuickTravel::Cache.cache('status-check') { 'start' }
      unless QuickTravel::Cache.cache('status-check') == 'start'
        fail RuntimeError, 'Failed to cache'
      end

      QuickTravel::Cache.clear
      QuickTravel::Cache.cache('status-check') { nil }
      unless QuickTravel::Cache.cache('status-check') == nil
        fail RuntimeError, 'Failed to cache'
      end
    end
  end
end
