require 'quick_travel/adapter'

module QuickTravel
  class Configuration
    attr_accessor :url, :access_key, :version

    def url=(url)
      @url = url
      QuickTravel::Adapter.base_uri url
    end

    attr_writer :access_key
  end

  def self.configure
    yield QuickTravel.config
  end

  def self.config
    @config ||= QuickTravel::Configuration.new
  end

  def self.url
    config.url
  end
end
