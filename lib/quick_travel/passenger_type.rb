require 'quick_travel/adapter'

module QuickTravel
  class PassengerType < Adapter
    self.api_base = '/passenger_types'
    self.lookup = true

    def self.passenger_counts(count_hash)
      applicable_types = count_hash.reject { |_t, c| c.zero? }
      applicable_types.map do |type, count|
        pluralize(count, find(type).try(:name))
      end
    end

    def self.pluralize(count, singular, plural = nil)
      "#{count || 0} " + ((count == 1) ? singular : (plural || singular.pluralize))
    end
  end
end
