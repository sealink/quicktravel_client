require 'quick_travel/adapter'

module QuickTravel
  class Address < Adapter
    def country_name
      QuickTravel::Country.find(@country_id).name
    end

    def to_s
      "#{address_line1} #{address_line2}, #{city}, #{post_code}, #{state}, #{country_name}"
    end
  end
end
