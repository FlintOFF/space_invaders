require 'test_helper'

class V1::AdminTargetsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    @admin = FactoryBot.create(:user, admin: true)
    @target = FactoryBot.create(:target)

    log_in(@admin)
  end

  #todo: check access

  context 'POST /admin/targets' do
    should 'return target info' do
      post '/admin/targets', FactoryBot.build(:target).to_json
      assert_status(201)
      assert_action_show(Target.find(parsed_response[:id]), [:id, :radar_id, :title, :description, :kind, :frame, :created_at, :updated_at])
    end
  end

  context 'PUT /admin/radars/:id' do
    should 'return target info' do
      put "/admin/targets/#{@target.id}", { title: Time.now.to_i }.to_json
      assert_status(200)
      assert_action_show(@target.reload, [:id, :radar_id, :title, :description, :kind, :frame, :created_at, :updated_at])
    end
  end

  context 'DELETE /admin/targets/:id' do
    should 'return successful' do
      delete "/admin/targets/#{@target.id}"
      assert_status(200)
      assert parsed_response.include?(:message)
      assert parsed_response[:message] == 'successful'
    end
  end
end
