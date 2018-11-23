module QuickTravel
  module Cache
    def cache(key, cache_options = {}, &block)
      QuickTravel::Cache.cache(key, cache_options) do
        block.call
      end
    end

    def self.cache(key, cache_options = {})
      return yield unless key.present?
      cached_value = cache_store.read(key)
      return cached_value unless cached_value.nil?
      return nil unless block_given?
      cache_options ||= {}
      cache_options[:expires_in] = 1.day unless cache_options.key?(:expires_in)
      yield.tap { |value| cache_store.write(key, value, cache_options) }
    end

    def self.delete(key)
      cache_store.delete(key)
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
