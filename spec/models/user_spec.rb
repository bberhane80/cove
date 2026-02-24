# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  bio                     :text
#  email                   :string
#  email_frequency         :string
#  encrypted_password      :string           default(""), not null
#  name                    :string
#  password                :string
#  receive_recommendations :boolean
#  remember_created_at     :datetime
#  reset_password_sent_at  :datetime
#  reset_password_token    :string
#  username                :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(username: 'testuser', email: 'test@example.com', password: 'password123')
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(username: 'testuser', password: 'password123')
    expect(user).not_to be_valid
  end


  it 'is invalid without a username' do
    user = User.new(email: 'test@example.com', password: 'password123')
    expect(user).not_to be_valid
  end
end
