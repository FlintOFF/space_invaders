require 'test_helper'

class V1::TargetsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    @target = FactoryBot.create(:target)
    log_in
  end

  context 'GET /targets' do
    should 'return list of targets' do
      get '/targets'
      assert_status(200)
      assert parsed_response.size == 1
    end
  end

  context 'GET /targets/:id' do
    should 'return target info' do
      get "/targets/#{@target.id}"
      assert_status(200)
      assert_action_show(@target, [:id, :radar_id, :title, :description, :kind, :frame, :created_at, :updated_at])
    end

    should 'return error when target is missing' do
      get '/targets/0'
      assert_status(404)
      assert parsed_response.include?(:error)
    end
  end
end
