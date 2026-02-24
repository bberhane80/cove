require 'rails_helper'

describe 'Listing search', type: :feature do
  let!(:user) { User.create!(username: 'testuser', email: 'test@example.com', password: 'password123') }
  let!(:listing) { Listing.create!(title: 'Cozy Home', address: '1 Main', city: 'Town', state: 'TS', price: 900, description: 'A cozy place', bedrooms: 2, bathrooms: 1) }

  it 'shows results for a search' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'

    visit listings_path
    find('.search-input').set('Cozy')
    click_button 'Smart Search'
    expect(page).to have_content('Cozy Home')
  end
end
