require 'rspec'
require 'rest_client'
require 'json'
require '../main/landlord'
require '../helpers/request_helpers'

# 10.1.20.127
shared_context "json helper" do
  let(:format) { JsonHelpers.new }
  let(:host) { "http://192.168.222.140:8080/landlords" }
  let(:media_type) { { :content_type => 'application/json' } }
end

describe 'Landlords' do
  include_context "json helper"

# GET request without errors
  it 'exist or has not been created yet' do

    response = RestClient.get(host, media_type)
    response_obj = JSON.parse(response)

    expect(response.code).to eq(200)

  end

# POST request without errors
  it 'should be created' do

    landlord = Landlord.new("Name1", "Surname1")
    request_body = format.to_json(landlord)

    response = RestClient.post(host, request_body, media_type)
    response_obj = JSON.parse(response.body)

    expect(response.code).to eq(201)
    expect(response_obj["firstName"]).to eql(landlord.firstName)
    expect(response_obj["lastName"]).to eql(landlord.lastName)
    expect(response_obj["trusted"]).to eql(landlord.trusted)

  end

  context "when first name" do

# POST request with validation errors (empty first name)
    it 'is empty' do

      landlord = Landlord.new("", "Surname1")
      request_body = format.to_json(landlord)

      response_obj = RestClient.post(host, request_body, media_type) do |response|
        if response.code == 400
          obj = JSON.parse(response)
        else
          abort "POST request failed"
        end
      end

      expect(response_obj["message"]).to eql("Fields are with validation errors")
      expect(response_obj["fieldErrorDTOs"][0]["fieldError"]).to eql("First name can not be empty")

    end

# POST request with validation errors (more than 20 chatacters))
    it 'has more than 20 characters length' do

      landlord = Landlord.new("1234567890_1234567890", "Surname1")
      request_body = format.to_json(landlord)

      response_obj = RestClient.post(host, request_body, media_type) do |response|
        if response.code == 400
          obj = JSON.parse(response)
        else
          abort "POST request failed"
        end
      end

      expect(response_obj["message"]).to eql("Fields are with validation errors")
      expect(response_obj["fieldErrorDTOs"][0]["fieldError"]).to eql("First name length can not be more than 20 characters")

    end

  end

# PUT request without errors (updating first name and last name)
  it 'should be updated' do

    landlord = Landlord.new("UpdatedFirstName", "UpdatedLastName")
    request_body = format.to_json(landlord)

    response = RestClient.get(host)
    response_obj = JSON.parse(response.body)

    landlord_id = response_obj[0]["id"]

    new_host = host + "/" + landlord_id

    new_response = RestClient.put(new_host, request_body, media_type)
    new_response_obj = JSON.parse(new_response.body)

    expect(response.code).to eq(200)
    expect(new_response_obj["message"]).to eql("LandLord with id: #{ landlord_id } successfully updated")

  end

  context "when id is incorrect" do

# PUT request with validation errors (landlord id does not exist)
    it 'should not be updated' do

      landlord_id = "123456"
      new_host = host + "/" + landlord_id

      landlord = Landlord.new("UpdatedFirstName", "UpdatedLastName")
      request_body = format.to_json(landlord)

      begin
      response = RestClient.put(new_host, request_body, media_type)
      rescue => e
        response_obj = JSON.parse(e.response)
      end

      expect(response_obj["message"]).to eql("There is no LandLord with id: #{ landlord_id }")

    end

  end

# DELETE request without errors
  it 'should be deleted' do

    response = RestClient.get(host)
    response_obj = JSON.parse(response.body)

    landlord_id = response_obj[0]["id"]

    new_host = host + "/" + landlord_id

    new_response = RestClient.delete(new_host, media_type)
    new_response_obj = JSON.parse(new_response.body)

    expect(response.code).to eq(200)
    expect(new_response_obj["message"]).to eql("LandLord with id: #{ landlord_id } successfully deleted")

  end

  context "when id is incorrect" do

# DELETE request with validation errors (landlord id does not exist)
    it 'is not exist' do

      landlord_id = "123456"
      new_host = host + "/" + landlord_id

      begin
        response = RestClient.delete(new_host, media_type)
      rescue => e
        response_obj = JSON.parse(e.response)
      end

      expect(response_obj["message"]).to eql("There is no LandLord with id: #{ landlord_id }")

    end

  end

end