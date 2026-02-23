require 'rails_helper'

describe 'API::V1::Base', type: :request do
  it 'returns http success for base endpoint' do
    get '/api/v1/base'
    expect(response).to have_http_status(:success)
  end
end
