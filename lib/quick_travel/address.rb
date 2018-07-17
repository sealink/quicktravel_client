require 'quick_travel/init_from_hash'

module QuickTravel
  class Address
    include QuickTravel::InitFromHash

    def country_name
      QuickTravel::Country.find(@country_id).name
    end

    def to_s
      "#{address_line1} #{address_line2}, #{city}, #{post_code}, #{state}, #{country_name}"
    end
  end
end
