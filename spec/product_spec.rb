require 'spec_helper'
require 'quick_travel/product'

describe QuickTravel::Product do
  before do
    VCR.use_cassette('product_show') do
      today = '2016-03-01'.to_date
      @product = QuickTravel::Product.find(6, # Executive Room
                                           first_travel_date: today,
                                           passenger_type_numbers: { '1' => 1 },
                                           date_range: { start_date: today, end_date: today + 1 }
       )
    end
  end

  it 'should create a useful product object' do
    expect(@product.pricing_details.minimum_price).to eq 400.to_money
    # @product.pricing_details_for_rack_rate.should_not be_present # TODO: Record new VCRs with new QT code
  end

  # TODO: Record new VCRs with new QT code
  # it 'should return a rack minimum price when requested due to agent being logged in' do
  #   VCR.use_cassette('product_show_as_agent') do
  #     today = '2013-02-14'.to_date
  #     @product = QuickTravel::Product.find(195,
  #       first_travel_date: today,
  #       passenger_type_numbers: {'1' => 1},
  #       rack_price_requested: true,
  #       date_range: {start_date: today, end_date: today + 1}
  #      )
  #   end
  #
  #   @product.pricing_details_for_rack_rate.should be_present
  # end
end

describe QuickTravel::Product do
  before do
    VCR.use_cassette('product_date_range_bookability') do
      @today = '2016-03-01'.to_date
      @products = QuickTravel::Product.fetch_and_arrange_by_resource_id_and_date(
        [3, 4, 6],
        travel_date: @today,
        duration: 7,
        default_pax_type_numbers: { '1' => 1 },
        passenger_type_numbers: { '1' => 2, '2' => 1 }
      )
    end
  end

  context 'accommodation product today' do
    subject(:product) { @products[6][@today.to_s] }
    it { should be_an_instance_of QuickTravel::Product }

    context 'pricing details' do
      subject(:pricing_details) { product.pricing_details }
      it { should be_an_instance_of QuickTravel::PricingDetails }

      context 'price per pax type' do
        let(:price_if_no_breakdown) { pricing_details.price_per_pax_type[0] }
        it 'should breakdown prices even if just a total' do
          expect(price_if_no_breakdown).to eq 250.to_money
        end
      end

      context 'minimum price' do
        subject(:minimum_price) { pricing_details.minimum_price }
        it { should eq 250.to_money } # $200 for 2 pax, $50 for extra passenger
      end

      context 'adjustments' do
        subject(:adjustments)   { pricing_details.adjustments_to_apply }
        it { should be_an_instance_of Array }

        context 'first adjustment' do
          subject(:adjustment) { adjustments.first }
          it { should be_an_instance_of Hash }
        end
      end
    end
  end
end
