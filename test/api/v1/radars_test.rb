require 'test_helper'

class V1::RadarsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    @radar = FactoryBot.create(:radar)
    log_in
  end

  context 'GET /radars' do
    should 'return list of radars' do
      get '/radars'
      assert_status(200)
      assert parsed_response.size == 1
    end
  end

  context 'GET /radars/:id' do
    should 'return radar info' do
      get "/radars/#{@radar.id}"
      assert_status(200)
      assert_action_show(@radar, [:id, :title, :description, :frame_height, :frame_width, :frame_symbols, :created_at, :updated_at])
    end

    should 'return error when radar is missing' do
      get '/radars/0'
      assert_status(404)
      assert parsed_response.include?(:error)
    end
  end
end
