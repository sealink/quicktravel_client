require 'spec_helper'
require 'quick_travel/adapter'

describe QuickTravel::Adapter do
  let(:response) { double code: 200, parsed_response: parsed_response }
  let(:parsed_response) { { test: true } }

  before do
    allow(QuickTravel::Api).to receive(:post).and_return(response)
  end

  context 'when the query contains empty arrays' do
    let(:url) { 'http://test.quicktravel.com.au' }
    let(:query) {
      {
        test: true,
        empty_array: [],
        sub_hash: { id: 42, values: [] }
      }
    }

    before do
      QuickTravel::Adapter.post_and_validate(url, query)
    end

    let(:expected_body) {
      {
        test: true,
        sub_hash: { id: 42 },
        access_key: an_instance_of(String)
      }
    }

    let(:expected_params) { a_hash_including body: expected_body }

    specify { expect(QuickTravel::Api).to have_received(:post).with(url, expected_params) }
  end
end
