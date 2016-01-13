require 'quick_travel/payment_type'
require 'rspec/its'

describe QuickTravel::PaymentType do
  subject(:payment_type) {
    QuickTravel::PaymentType.new(payment_method: 'credit_card',
                                 credit_card_brand: brand) }

  context 'MasterCard' do
    let(:brand) { 'MasterCard' }
    its(:code) { should eq 'master_card' }
  end

  context 'American Express' do
    let(:brand) { 'American Express' }
    its(:code) { should eq 'american_express' }
  end

  context 'payment info' do
    it 'should fetch payment info' do
      VCR.use_cassette 'payment_info' do
        expect(QuickTravel::PaymentType.information).to eq(
          'poli_pay' => { 'login' => 'S1234567' }
        )
      end
    end
  end
end
