module QuickTravel
  module InitFromHash
    def initialize(hash = {})
      return nil if hash.blank?

      define_readers(hash.keys)
      Parser.new(hash).parsed_attributes.each do |attr, val|
        # set datamember of the object using hash key and value
        if respond_to?("#{attr}=")
          send("#{attr}=", val)
        else
          instance_variable_set("@#{attr}".to_sym, val)
        end
      end
    end

    def define_readers(keys)
      keys.each do |key|
        next if respond_to?(key)
        define_singleton_method(key) { instance_variable_get("@#{key}") }
        if key.to_s.ends_with? '_cents'
          name = key.to_s.gsub(/_in_cents$/, '')
          define_singleton_method(name) {
            cents = instance_variable_get("@#{key}")
            return nil unless cents
            Money.new(cents)
          }
        end
      end
    end
  end

  class Parser
    def initialize(attributes)
      @attributes = attributes
    end

    def attributes
      @attributes ||= {}
    end

    def parsed_attributes
      @parsed_attributes ||= parse_attributes
    end

    private

    def parse_attributes
      attributes.map.with_object({}) do |(attribute, value), hash|
        hash[attribute] = parse(attribute, value)
      end
    end

    def parse(attribute, value)
      return nil if value.nil?
      return convert(value, :to_date) if attribute.to_s.ends_with?('_date')
      return convert(value, :to_date) if attribute.to_s.ends_with?('_on')
      # to_datetime as it converts to app time zone, to_time converts to system time zone
      return convert(value, :to_datetime) if attribute.to_s.ends_with?('_time')
      return convert(value, :to_datetime) if attribute.to_s.ends_with?('_at')
      value
    end

    def convert(value, conversion_method)
      convertable_value = value.is_a?(Hash) ? value['_value'] : value
      convertable_value.try(conversion_method) || convertable_value
    end
  end
end
