require 'quick_travel/adapter'
require 'quick_travel/encrypt'

module QuickTravel
  class DocumentGroup < Adapter
    self.api_base = "/front_office/bookings/#{@booking_id}/document_groups"

    def pdf_url
      "#{QuickTravel.config.url}/api/bookings/#{@booking_id}/document_groups/#{@id}.pdf?key=#{Encrypt.access_key("document_group:#{@id}")}"
    end
  end
end
