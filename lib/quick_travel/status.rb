module QuickTravel
  class Status
    def self.key
      # NOTE: This is not pretty, but we need to use a unique key per server
      @key ||= "status-check##{SecureRandom.hex}"
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
