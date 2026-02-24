require 'rails_helper'

describe AiListingSearchService, type: :service do
  let(:query) { '2 bedroom in Testville' }
  let!(:listing) { Listing.create!(title: 'Test', address: '123 Main', city: 'Testville', state: 'TS', price: 1000, bedrooms: 2, bathrooms: 1, description: 'A great place') }

  it 'returns listings for a valid query' do
    allow_any_instance_of(AiListingSearchService).to receive(:parse_response).and_return({listings: [listing], explanation: 'Found 1'})
    result = AiListingSearchService.new(query).search
    expect(result[:listings]).to include(listing)
  end
end
