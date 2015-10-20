module QuickTravel
  module Cache
    def cache(key, cache_options = {}, &block)
      QuickTravel::Cache.cache(key, cache_options) do
        block.call
      end
    end

    def self.cache(key, cache_options = {})
      cached_value = cache_store.read(key)
      return cached_value unless cached_value.nil?
      return nil unless block_given?
      yield.tap { |value| cache_store.write(key, value, cache_options) }
    end

    def self.clear
      cache_store.clear
    end

    def self.cache_store
      @@cache_store
    end

    def self.cache_store=(store)
      @@cache_store = store
    end
  end
end
