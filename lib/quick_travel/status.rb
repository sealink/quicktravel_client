module QuickTravel
  class Status
    def self.key
      "status-check"
    end

    def self.check!
      # Test Cache
      QuickTravel::Cache.delete(key)
      QuickTravel::Cache.cache(key) { 'start' }
      unless QuickTravel::Cache.cache(key) == 'start'
        fail RuntimeError, 'Failed to cache status-check'
      end

      QuickTravel::Cache.delete(key)
      QuickTravel::Cache.cache(key) { nil }
      unless QuickTravel::Cache.cache(key) == nil
        fail RuntimeError, 'Failed to clear status-check cache'
      end
    end
  end
end
