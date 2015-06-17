require 'rspec'
require 'rest_client'
require 'json'
require '../main/apartment'
require '../helpers/request_helpers'

shared_context "json helper" do
  let(:format) { JsonHelpers.new }
  let(:host) { "http://192.168.222.140:8080/landlords/fuamTNgP/apartments" }
  let(:media_type) { { :content_type => 'application/json' } }
end

describe 'Apartments of Landlord with id "ustxBoXa"' do
  include_context "json helper"

  it 'all should be shown' do

    response = RestClient.get(host)

    response_obj = JSON.parse(response.body)

    expect(response.code).to eq(200)
    expect(response_obj.size).to eq(0)

  end

  it 'should be shown according to square min/max parameters' do

    request_params = {:minSq => 50, :maxSq => 100}

    response = RestClient.get(host,   :params => request_params)

    response_obj = JSON.parse(response.body)

    expect(response.code).to eq(200)
    expect(response_obj.size).to eq(0)

  end


end