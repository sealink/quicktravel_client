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

  context 'when response non standard' do
    let(:url) { 'https://httpstat.us/418' }

    let(:adapter_response) {
      VCR.use_cassette 'wrong_url' do
        QuickTravel::Adapter.get_and_validate(url)
      end
    }

    specify do
      expect { adapter_response }.to raise_error(
        QuickTravel::AdapterError,
        /418 I'm a teapot/
      )
    end
  end

  context 'when cache options present' do
    subject(:all) do
      QuickTravel::Adapter.call_and_validate(:get, 'some_path', {}, { cache: 'test_key', cache_options: { expires_in: 3.minutes } })
    end
    let(:api) { double }

    before do
      QuickTravel::Cache.cache_store.clear
      stub_const('QuickTravel::Api', api)
      allow(api).to receive(:call_and_validate) { [{id: 1}, {id: 2}] }
      all
    end

    specify { expect(api).to have_received(:call_and_validate).once }

    context 'when called again' do
      before do
        QuickTravel::Adapter.call_and_validate(:get, 'some_path', {}, { cache: 'test_key', cache_options: { expires_in: 3.minutes } })
      end

      specify { expect(api).to have_received(:call_and_validate).once } # not called again
    end

    context 'when called with different key' do
      before do
        QuickTravel::Adapter.call_and_validate(:get, 'some_path', {}, { cache: 'test_key1', cache_options: { expires_in: 3.minutes } })
      end

      specify { expect(api).to have_received(:call_and_validate).twice }
    end
  end
end
