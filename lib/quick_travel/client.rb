require 'quick_travel/adapter'

module QuickTravel
  class Client < Adapter
    attr_accessor :id, :party_id, :surchargeless, :client_type,
                  :contact_phone, :contact_mobile, :contact_email,
                  :name,
                  :first_name, :last_name
  end
end
