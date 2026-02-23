require 'rails_helper'

describe 'Listings Search', type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123', username: 'testuser') }

  before do
    sign_in user
  end

  it 'returns success for index' do
    get listings_path
    expect(response).to have_http_status(:success)
  end

  it 'returns listings matching a search query' do
    Listing.create!(
      title: 'Sunny Loft',
      description: 'Bright and airy',
      city: 'Boston',
      state: 'MA',
      price: 2000,
      bedrooms: 1,
      bathrooms: 1.0
    )
    get listings_path, params: { search: 'loft' }
    expect(response.body).to include('Sunny Loft')
  end
end
