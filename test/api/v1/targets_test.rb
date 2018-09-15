require 'test_helper'

class V1::TargetsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    setup_headers
    @target = FactoryBot.create(:target)
  end

  context 'GET /targets' do
    should 'return list of targets' do
      log_in
      get '/targets'
      assert_status(200)
      assert parsed_response.size == 1
    end
  end

  context 'GET /targets/:id' do
    should 'return target info' do
      log_in
      get "/targets/#{@target.id}"
      assert_status(200)
      assert_action_show(@target, [:id, :radar_id, :title, :description, :kind, :frame, :created_at, :updated_at])
    end

    should 'return error when target is missing' do
      log_in
      get '/targets/0'
      assert_status(404)
      assert parsed_response.include?(:error)
    end
  end

  context 'work with user area without token' do
    should 'return error' do
      get '/targets'
      assert_status(403)
      assert parsed_response[:error] == 'Forbidden'
    end
  end
end
