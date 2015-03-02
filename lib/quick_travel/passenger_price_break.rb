require 'quick_travel/adapter'

module QuickTravel
  class PassengerPriceBreak < Adapter
    attr_accessor :amount_in_cents
    money :amount
  end
end
