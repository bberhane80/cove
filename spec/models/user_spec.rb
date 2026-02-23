require 'rails_helper'

describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(email: 'test@example.com', password: 'password123')
    expect(user).to be_valid
  end
end
