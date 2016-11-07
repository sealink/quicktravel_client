require 'httparty'
require 'pp'
require 'json'
require 'active_support/core_ext'
require 'money'
require 'facets/hash/recurse'
require 'facets/hash/delete_values'

require 'quick_travel/config'
require 'quick_travel/adapter_error'
require 'quick_travel/init_from_hash'

module QuickTravel
  class Adapter
    include QuickTravel::InitFromHash

    class_attribute :api_base, :lookup

    # In case of object_key_name, we need to extract each record by a key
    #
    # Example:
    # [
    #   { :passenger_type => {"position"=>1, "name"=>"Adult", "maximum_age"=>30, "id"=>1} },
    #   { :passenger_type => {"position"=>2, "name"=>"Child", "maximum_age"=>15, "id"=>2} }
    # ]
    class_attribute :object_key # Key of sub-objects (i.e. convert under a key)

    def initialize(hash = {})
      return nil if hash.blank?
      define_readers(hash.keys)
      super(Parser.new(hash).parsed_attributes)
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

    def self.has_many(relation_name, options = {})
      define_method relation_name do
        instance_variable_get("@#{relation_name}") || instance_variable_set(
          "@#{relation_name}",
          begin
            klass = QuickTravel.const_get(options[:class_name] || relation_name.to_s.singularize.classify)
            Array(instance_variable_get("@#{relation_name}_attributes")).map { |attr|
              klass.new(attr)
            }
          end
        )
      end
    end

    def self.belongs_to(relation_name, options = {})
      define_method relation_name do
        instance_variable_get("@#{relation_name}") || instance_variable_set(
          "@#{relation_name}",
          begin
            attrs = instance_variable_get("@#{relation_name}_attributes")
            return nil unless attrs
            klass = QuickTravel.const_get(options[:class_name] || relation_name.to_s.singularize.classify)
            klass.new(attrs)
          end
        )
      end
    end

    def self.find(id, opts = {})
      check_id!(id)
      if lookup
        all.detect { |o| o.id == id.to_i }
      else
        find_all!("#{api_base}/#{id}.json", opts).first
      end
    end

    def self.all(opts = {})
      if lookup
        cache_name = ["#{name}.all-attrs", opts.to_param].reject(&:blank?).join('?')
        find_all!("#{api_base}.json", opts.merge(cache: cache_name))
      else
        find_all!("#{api_base}.json", opts)
      end
    end

    def self.create(options = {})
      post_and_validate("#{api_base}.json", options)
    end

    def self.update(id, options = {})
      check_id!(id)
      put_and_validate("#{api_base}/#{id}.json", options)
    end

    def self.qt_date_format_conversion(str)
      qt_date_format_conversion!(str)
    rescue ArgumentError
    end

    def self.qt_date_format_conversion!(str)
      Date.strptime(str, '%d/%m/%Y').strftime('%d-%m-%Y')
    end

    def to_hash
      instance_values
    end

    protected

    def self.check_id!(id)
      Integer(id)
    rescue ArgumentError, # if invalid string
           TypeError # if nil
      fail ArgumentError, 'id must be an integer'
    end

    def self.find_all!(request_path, opts = {})
      response = if opts.key? :cache
        QuickTravel::Cache.cache(opts[:cache], opts[:cache_options]) {
          get_and_validate(request_path, opts.except(:cache, :cache_options))
        }
      else
        get_and_validate(request_path, opts, return_response_object: true)
      end
      full_response = response.respond_to? :parsed_response
      parsed_response = full_response ? response.parsed_response : response

      deserializer = Deserializer.new(parsed_response)
      objects = Array.wrap(deserializer.extract_under_root(self))

      if full_response && response.headers['pagination'].present?
        pagination_headers = ::JSON.parse(response.headers['pagination'])
        WillPaginate::Collection.create(pagination_headers['current_page'], pagination_headers['per_page'], pagination_headers['total_entries']) do |pager|
          pager.replace(objects)
        end
      else
        objects
      end
    end

    class Deserializer
      def initialize(data)
        @data = data
      end

      # Extract the 'root' -- the data must be a direct collection of objects
      #
      #  opts[:object_key_name] => inside each hash extract attributes under a subkey (per object)
      def extract_under_root(klass, opts = {})
        self.class.extract(@data, klass, opts)
      end

      # Extract under a specified key in the data
      def extract(key, klass, opts = {})
        collection_data = @data[key]
        fail "No collection key [#{key}] found in data from API" if collection_data.blank?
        self.class.extract(collection_data, klass, opts)
      end

      def self.extract(raw_objects, klass, opts = {})
        objects = Array.wrap(raw_objects)
        if opts[:object_key_name]
          objects = objects.map { |item| item[opts[:object_key_name]] }
        end
        objects.map { |item| klass.new(item) }
      end
    end

    # The above find_all and the above find
    # all suck
    #
    # We should make it standard behaviour that objects
    # instantiate on get...
    #
    # Also, we should combine the two methods (get and validate) automatically...
    #
    #  -> I found one - we can set custom parser()
    #     but that won't have access to response code only the body
    #
    #  Better idea:
    #  Just override get, put, post and delete?
    #  If you need the originals, alias as raw.get() ?
    #  Seems to solve both issues...

    def get_and_validate(path, query = {}, opts = {})
      self.class.get_and_validate(path, query, opts)
    end

    def post_and_validate(path, query = {}, opts = {})
      self.class.post_and_validate(path, query, opts)
    end

    def put_and_validate(path, query = {}, opts = {})
      self.class.put_and_validate(path, query, opts)
    end

    def delete_and_validate(path, query = {}, opts = {})
      self.class.delete_and_validate(path, query, opts)
    end

    def self.get_and_validate(path, query = {}, opts = {})
      call_and_validate(:get, path, query, opts)
    end

    def self.post_and_validate(path, query = {}, opts = {})
      call_and_validate(:post, path, query, opts)
    end

    def self.put_and_validate(path, query = {}, opts = {})
      call_and_validate(:put, path, query, opts)
    end

    def self.delete_and_validate(path, query = {}, opts = {})
      call_and_validate(:delete, path, query, opts)
    end

    def self.call_and_validate(http_method, path, query = {}, opts = {})
      Api.call_and_validate(http_method, path, query, opts)
    end

    def self.base_uri(uri = nil)
      Api.base_uri uri
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
      convertable_value.send(conversion_method)
    end
  end

  class Api
    include HTTParty

    def self.call_and_validate(http_method, path, query = {}, opts = {})
      http_params = opts.clone
      return_response_object = http_params.delete(:return_response_object)

      # Set default token
      http_params[:query]   ||= FilterQuery.new(query).call
      http_params[:headers] ||= {}
      http_params[:headers]['Content-length'] = '0' if http_params[:body].blank?
      expect = http_params.delete(:expect)

      # Use :body instead of :query for put/post.
      #
      # Causes webrick to give back error - -maybe other servers too.
      http_params[:body] ||= {}
      if [:put, :post].include?(http_method.to_sym)
        http_params[:body].merge!(http_params.delete(:query))
      end
      http_params[:body][:access_key] = QuickTravel.config.access_key
      http_params[:follow_redirects] = false

      begin
        response = self.send(http_method, path, http_params)
      rescue Errno::ECONNREFUSED
        raise ConnectionError.new('Connection refused')
      rescue SocketError
        raise ConnectionError.new('Socket error')
      rescue Timeout::Error
        raise ConnectionError.new('Timeout error')
      end

      if expect && expect == :json && !response.parsed_response.is_a?(Hash)
        fail AdapterError, <<-FAIL
          Request expected to be json but failed. Debug information below:
          http_method: #{http_method.inspect}
          path: #{path.inspect}
          http_params: #{http_params.inspect}
          response object: #{response.inspect}
          parsed_response: #{response.parsed_response.inspect}
        FAIL
      end

      validate!(response)

      if return_response_object
        response
      else
        response.parsed_response
      end
    end

    # Do standard validations on response
    #
    # Firstly, check if a valid HTTP code was returned
    # Secondly, check for presence of "error" key in returned hash
    def self.validate!(response)
      case response.code
      when 300..399 # redirects
        fail ConnectionError.new('We were redirected. QT YML configuration appears to be incorrect. Verify your URL and API.')
      when 400..599 # client and server errors
        fail AdapterError.new(response)
      end

      if response_contains_error?(response)
        fail AdapterError, response
      end
    end

    def self.response_contains_error?(response)
      parsed_response = response.parsed_response
      parsed_response.is_a?(Hash) && parsed_response.key?('error')
    end

    # HTTParty v0.14.0 introduced this change:
    #
    #   * [allow empty array to be used as param](https://github.com/jnunemaker/httparty/pull/477)
    #
    # Unfortunately, when submitting an empty array as a parameter,
    # Rack interprets it as an array containing an empty string:
    #
    #   Rack::Utils.parse_nested_query('array[]=') #=> {"array"=>[""]}
    #
    # The workaround is to avoid sending empty arrays to Rack based web applications
    class FilterQuery
      def initialize(query)
        @query = query
      end

      def call
        return @query unless @query.is_a? Hash
        without_empty_arrays
      end

      private

      def without_empty_arrays
        @query.recurse { |hash|
          hash.delete_values([])
          hash
        }
      end
    end
  end
end
