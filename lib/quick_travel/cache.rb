module QuickTravel
  module Cache
    def cache(key, &block)
      QuickTravel::Cache.cache(key) do
        block.call
      end
    end

    def self.cache(key)
      cached_value = cache_store.read(key)
      return cached_value unless cached_value.nil?
      return nil unless block_given?
      yield.tap { |value| cache_store.write(key, value) }
    end

    def self.cache_store
      @@cache_store
    end

    def self.cache_store=(store)
      @@cache_store = store
    end
  end

  class DefaultCacheStore
    def initialize
      @store = {}
    end

    def write(key, value)
      @store[key] = value
    end

    def read(key)
      @store[key]
    end
  end
end
