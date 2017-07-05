require 'spec_helper'
require 'quick_travel/price_changes/price_change'

RSpec.describe QuickTravel::PriceChanges::PriceChange do
  let(:attrs) { {
		"target" => {
			"type" => "Reservation",
			"id" => 9915496
		},
		"original_price_in_cents" => 19600,
		"changed_price_in_cents" => 18800,
		"price_change_in_cents" => -800,
		"reason" => "Online Discount and Special Price",
		"reasons" => [
			"Online Discount",
      "Special Price"
		],
		"discounted_price_in_cents" => 18800,
		"discount_in_cents" => -800,
		"root" => {
			"target" => {
				"type" => "Reservation",
				"id" => 9915496
			},
			"original_price_in_cents" => 19600,
			"changed_price_in_cents" => 18800,
			"price_change_in_cents" => -800,
			"reason" => "Online Discount and Special Price",
			"reasons" => [
				"Online Discount",
        "Special Price"
			],
			"discounted_price_in_cents" => 18800,
			"discount_in_cents" => -800
		},
		"children" => []
	} }
  let(:price_change) { QuickTravel::PriceChanges::PriceChange.new(attrs) }

  it 'should have the correct attributes' do
    expect(price_change.target.type).to eq 'Reservation'
    expect(price_change.original_price.cents).to eq 19600
    expect(price_change.changed_price.cents).to eq 18800
    expect(price_change.price_change.cents).to eq -800
    expect(price_change.reason).to eq 'Online Discount and Special Price'
    expect(price_change.reasons).to eq ['Online Discount', 'Special Price']
  end
end
