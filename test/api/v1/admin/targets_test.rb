require 'test_helper'

class V1::AdminTargetsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    setup_headers
    @admin = FactoryBot.create(:user, admin: true)
    @target = FactoryBot.create(:target)
  end

  context 'POST /admin/targets' do
    should 'return target info' do
      log_in(@admin)
      post '/admin/targets', FactoryBot.build(:target).to_json
      assert_status(201)
      assert_action_show(Target.find(parsed_response[:id]), [:id, :radar_id, :title, :description, :kind, :frame, :created_at, :updated_at])
    end
  end

  context 'PUT /admin/radars/:id' do
    should 'return target info' do
      log_in(@admin)
      put "/admin/targets/#{@target.id}", { title: Time.now.to_i }.to_json
      assert_status(200)
      assert_action_show(@target.reload, [:id, :radar_id, :title, :description, :kind, :frame, :created_at, :updated_at])
    end
  end

  context 'DELETE /admin/targets/:id' do
    should 'return successful' do
      log_in(@admin)
      delete "/admin/targets/#{@target.id}"
      assert_status(200)
      assert parsed_response.include?(:message)
      assert parsed_response[:message] == 'successful'
    end
  end

  context 'work with admin area as the regular user' do
    should 'return error' do
      log_in
      delete "/admin/targets/#{@target.id}"
      assert_status(403)
      assert parsed_response[:error] == 'Forbidden'
    end
  end
end
