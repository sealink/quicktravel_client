require 'spec_helper'
require 'quick_travel/credit_card'

describe QuickTravel::CreditCard do
  it 'determine the correct payment type for credit card number' do
    expect(QuickTravel::CreditCard.type_from_number('4000123456780123')).to eq 'visa'
    expect(QuickTravel::CreditCard.type_from_number('5400123456780123')).to eq 'master'
    expect(QuickTravel::CreditCard.type_from_number('3600123456780123')).to eq 'diners_club'
    expect(QuickTravel::CreditCard.type_from_number('3400123456780123')).to eq 'american_express'
  end
end
