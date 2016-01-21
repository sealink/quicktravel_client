require 'quick_travel/adapter'

module QuickTravel
  class Document < Adapter
    self.api_base = "/front_office/bookings/#{@booking_id}/documents"

    # We used to direct the browser to QT directly
    # Now, we proxy over to it, and return the data
    # def pdf_url
    # #"#{QuickTravel.config.url}/api/bookings/#{@booking_id}/documents/#{@id}.pdf?key=#{access_key("document:#{@id}")}"
    # end

    # Do a second request fetching the PDF
    def fetch_pdf
      get_and_validate "/api/bookings/#{@booking_id}/documents/#{@id}.pdf"
    end
  end
end
