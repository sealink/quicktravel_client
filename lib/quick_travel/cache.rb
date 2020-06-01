module QuickTravel
  module Cache
    def cache(key, cache_options = {}, &block)
      QuickTravel::Cache.cache(key, cache_options) do
        block.call
      end
    end

    def self.cache(key, cache_options = nil)
      return yield unless key.present?
      cache_options ||= {}
      key = "#{@@namespace}_#{key}" unless cache_options[:disable_namespacing]
      cached_value = cache_store.read(key)
      return cached_value unless cache_empty?(cached_value)
      return nil unless block_given?
      cache_options ||= {}
      cache_options[:expires_in] = 1.day unless cache_options.key?(:expires_in)
      yield.tap { |value| cache_store.write(key, value, cache_options) }
    end

    def self.cache_empty?(cached_value)
      if cached_value.respond_to?(:body)
        return cached_value.body.nil? || cached_value.body.empty?
      end
      cached_value.nil?
    end

    def self.delete(key, namespace = true)
      key = "#{@@namespace}_#{key}" if namespace
      cache_store.delete(key)
    end

    def self.clear
      cache_store.clear
    end

    def self.cache_store
      @@cache_store
    end

    def self.cache_store=(session)
      @@cache_store = session
    end

    def self.namespace
      @@namespace
    end

    def self.namespace=(namespace)
      @@namespace = namespace
    end
  end
end
