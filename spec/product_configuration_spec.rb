require 'spec_helper'
require 'money'
require 'quick_travel/product_configuration'

describe QuickTravel::ProductConfiguration do
  ADULT_PASSENGER_TYPE_ID = 0
  CHILD_PASSENGER_TYPE_ID = 1

  let(:extra_pick_available) { false }
  let(:extra_pick_minimum_price) { Money.new(2) }

  let(:applied_rules) { [] }
  let(:extra_pick_applied_rules) { [] }

  let(:extra_pick_pricing_details) do
    double(
      applied_rules: extra_pick_applied_rules,
      price_per_pax_type: [],
      minimum_price_with_adjustments: extra_pick_minimum_price
    )
  end

  let(:extra_pick_product) do
    double(
      extras: [],
      pricing_details: extra_pick_pricing_details,
      available?: extra_pick_available
    )
  end

  let(:unpriced_extra_pick_product) { double(extras: [], available?: true) }

  let(:extras) { [extra_pick_product] }

  let(:available) { false }
  let(:minimum_price) { Money.new(10) }
  let(:minimum_without_rules_price) { Money.new(100) }
  let(:minimum_rack_price) { Money.new(50) }

  let(:pricing_details) do
    double(
      applied_rules: applied_rules,
      price_per_pax_type: [2, 1],
      minimum_price_with_adjustments: minimum_price
    )
  end

  let(:pricing_details_for_rack_rate) do
    double(
      applied_rules: [],
      price_per_pax_type: [],
      minimum_price_with_adjustments: minimum_rack_price
    )
  end

  let(:pricing_details_without_rules) do
    double(
      applied_rules: [],
      price_per_pax_type: [],
      minimum_price_with_adjustments: minimum_without_rules_price
    )
  end

  let(:product) do
    double(
      extras: extras,
      available?: available,
      pricing_details: pricing_details,
      pricing_details_without_rules: pricing_details_without_rules,
      pricing_details_for_rack_rate: pricing_details_for_rack_rate
    )
  end

  subject(:config) { QuickTravel::ProductConfiguration.new(product) }

  context '#initialize' do
    it 'should create the extra pick configurations' do
      expect(subject.extra_pick_configurations.size).to be 1
    end
  end

  context 'selections' do
    it { is_expected.not_to be_selected }

    context '#select!' do
      before { subject.select! }
      it { is_expected.to be_selected }

      context '#deselect!' do
        before { subject.deselect! }
        it { is_expected.not_to be_selected }
      end
    end
  end

  context '#available?' do
    context 'the product is available' do
      let(:available) { true }
      it { is_expected.to be_available }

      context 'extra pick unavailable' do
        let(:extra_pick_available) { false }

        context 'non selected extra picks' do
          it { is_expected.to be_available }
        end

        context 'selected extra pick' do
          before { subject.select_extra_pick(extra_pick_product) }
          it { is_expected.not_to be_available }
        end
      end
    end

    context 'the product is unavailable' do
      let(:available) { false }
      it { is_expected.not_to be_available }
    end
  end

  context '#priced?' do
    context 'when the pricing details are present' do
      it { is_expected.to be_priced }
    end

    context 'when no pricing details are present' do
      let(:pricing_details) { nil }
      it { is_expected.not_to be_priced }
    end

    context 'when pricing details are omitted' do
      let(:product) do
        double(
          extras: extras,
          available?: available
        )
      end

      it { is_expected.not_to be_priced }
    end
  end

  context '#price' do
    subject { config.price }
    it { is_expected.to eq minimum_price }
  end

  context '#price_without_rules' do
    subject { config.price_without_rules }

    context 'when the rules are not defined' do
      let(:pricing_details_without_rules) { nil }
      it { is_expected.to eq config.price }
    end

    context 'when the rules are defined' do
      it { is_expected.to eq minimum_without_rules_price }
    end
  end

  context '#price_for_rack_rate' do
    subject { config.price_for_rack_rate }

    context 'when the rules are not defined' do
      let(:pricing_details_for_rack_rate) { nil }
      it { is_expected.to eq config.price }
    end

    context 'when the rules are defined' do
      it { is_expected.to eq minimum_rack_price }
    end
  end

  context '#total_price' do
    subject { config.total_price }

    context 'when there are no selected extra picks' do
      it { is_expected.to eq config.price }
    end

    context 'when there are selected extra picks' do
      before { config.select_extra_pick(extra_pick_product) }
      it { is_expected.to eq extra_pick_minimum_price + minimum_price }

      context 'without a price' do
        let(:extra_pick_pricing_details) { nil }
        it { is_expected.to eq config.price }
      end
    end
  end

  context '#total_price_without_rules' do
    subject { config.total_price_without_rules }
    context 'when there are no selected extra picks' do
      it { is_expected.to eq config.price_without_rules }
    end
  end

  context '#total_price_for_rack_rate' do
    subject { config.total_price_for_rack_rate }
    context 'when there are no selected extra picks' do
      it { is_expected.to eq config.price_for_rack_rate }
    end
  end

  context '#applied_rules' do
    let(:applied_rules) { [1, 1, 2, 2] }
    subject { config.applied_rules }
    it { is_expected.to eq [1, 2] }
  end

  context '#total_applied_rules' do
    let(:applied_rules) { [1, 1, 2, 2] }
    let(:extra_pick_applied_rules) { [1, 3] }
    before do
      subject.select_extra_pick(extra_pick_product)
    end
    it 'should return unique rules from product and selected extra picks' do
      expect(subject.total_applied_rules).to eq [1, 2, 3]
    end
  end

  context '#price_per_passenger_type' do
    it 'should return a price for adult' do
      expect(subject.price_per_passenger_type(ADULT_PASSENGER_TYPE_ID)).to be 2
    end

    it 'should return a price for child' do
      expect(subject.price_per_passenger_type(CHILD_PASSENGER_TYPE_ID)).to be 1
    end
  end

  context '#selected_extra_pick_configurations' do
    it 'should have no selected extra picks by default' do
      expect(subject.selected_extra_pick_configurations).to be_empty
    end
  end

  context '#available_extra_pick_configurations' do
    context 'when there are available extra picks' do
      let(:extra_pick_available) { true }
      it 'should return the available extra picks' do
        expect(subject.available_extra_pick_configurations.size).to be 1
      end
    end

    context 'when there are no available extra picks' do
      let(:extra_pick_available) { false }
      it 'should return the available extra picks' do
        expect(subject.available_extra_pick_configurations).to be_empty
      end
    end
  end

  context '#select_extra_picks' do
    let(:extras) { [extra_pick_product, unpriced_extra_pick_product] }
    before do
      subject.select_extra_picks(extras)
    end

    it 'should select all the extra pick configurations' do
      expect(subject.extra_pick_configurations.all?(&:selected?)).to be true
    end
  end

  context '#select_extra_pick' do
    context 'when the extra pick does not exist' do
      it 'should raise an exception' do
        expect { subject.select_extra_pick(product) }.to raise_error(
          ArgumentError,
          'That extra pick does not belong to the product'
        )
      end
    end
  end
end
