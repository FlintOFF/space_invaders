require 'test_helper'

class V1::RadarsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    setup_headers
    @radar = FactoryBot.create(:radar)
  end

  context 'GET /radars' do
    should 'return list of radars' do
      log_in
      get '/radars'
      assert_status(200)
      assert parsed_response.size == 1
    end
  end

  context 'GET /radars/:id' do
    should 'return radar info' do
      log_in
      get "/radars/#{@radar.id}"
      assert_status(200)
      assert_action_show(@radar, [:id, :title, :description, :frame_height, :frame_width, :frame_symbols, :created_at, :updated_at])
    end

    should 'return error when radar is missing' do
      log_in
      get '/radars/0'
      assert_status(404)
      assert parsed_response.include?(:error)
    end
  end

  context 'work with user area without token' do
    should 'return error' do
      get '/radars'
      assert_status(403)
      assert parsed_response[:error] == 'Forbidden'
    end
  end
end
