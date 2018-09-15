require 'test_helper'

class V1::AdminRadarsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    setup_headers
    @admin = FactoryBot.create(:user, admin: true)
    @radar = FactoryBot.create(:radar)
  end

  context 'POST /admin/radars' do
    should 'return radar info' do
      log_in(@admin)
      post '/admin/radars', FactoryBot.build(:radar).to_json
      assert_status(201)
      assert_action_show(Radar.find(parsed_response[:id]), [:id, :title, :description, :frame_height, :frame_width, :frame_symbols, :created_at, :updated_at])
    end
  end

  context 'PUT /admin/radars/:id' do
    should 'return radar info' do
      log_in(@admin)
      put "/admin/radars/#{@radar.id}", { title: Time.now.to_i }.to_json
      assert_status(200)
      assert_action_show(@radar.reload, [:id, :title, :description, :frame_height, :frame_width, :frame_symbols, :created_at, :updated_at])
    end
  end

  context 'DELETE /admin/radars/:id' do
    should 'return successful' do
      log_in(@admin)
      delete "/admin/radars/#{@radar.id}"
      assert_status(200)
      assert parsed_response.include?(:message)
      assert parsed_response[:message] == 'successful'
    end
  end

  context 'work with admin area as the regular user' do
    should 'return error' do
      log_in
      delete "/admin/radars/#{@radar.id}"
      assert_status(403)
      assert parsed_response[:error] == 'Forbidden'
    end
  end
end
