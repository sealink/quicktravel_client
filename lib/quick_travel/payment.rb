require 'quick_travel/adapter'
require 'quick_travel/credit_card'

module QuickTravel
  class Payment < Adapter
    attr_accessor :id, :payment_type_id, :amount_in_cents, :authorization, :success, :created_at
    money :amount

    def payment_type
      QuickTravel::PaymentType.find(@payment_type_id)
    end

    def self.create(options = {})
      post_and_validate("/front_office/bookings/#{options[:booking_id]}/payments.json", options)
    end

    def self.charge_account(booking, payment_options = {})
      payment_type = booking.on_account_payment_type

      if payment_type.nil?
        fail ArgumentError, 'Booking not allowed to be paid on account'
      end

      agent_booking_reference = payment_options[:agent_booking_reference]
      amount                  = payment_options[:amount].presence

      options = {
        payment: {
          payment_type_id:   payment_type.id,
          uid:               SecureRandom.hex(16),
          comment:           agent_booking_reference,
          amount:            amount,
          currency_iso_code: 'AUD'
        },
        pay_balance: amount.nil?
      }

      post_and_validate("/api/bookings/#{booking.id}/payments.json", options)
    end
  end
end
