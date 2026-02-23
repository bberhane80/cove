require 'rails_helper'

describe 'Listings Search', type: :request do
  it 'returns success for index' do
    get listings_path
    expect(response).to have_http_status(:success)
  end

  it 'returns listings matching a search query' do
    Listing.create!(title: 'Sunny Loft', description: 'Bright and airy', city: 'Boston', price: 2000)
    get listings_path, params: { search: 'loft' }
    expect(response.body).to include('Sunny Loft')
  end
end
