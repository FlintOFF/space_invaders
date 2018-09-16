require 'test_helper'

class V1::TasksTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    setup_headers
    @user = FactoryBot.create(:user)
    @radar = FactoryBot.create(:radar)
    @target = FactoryBot.create(:target, radar: @radar)
    @task = FactoryBot.create(:task, user: @user, radar: @radar)
  end

  context 'GET /api/tasks' do
    should 'return list of tasks' do
      log_in(@user)
      get '/api/tasks'
      assert_status(200)
      assert parsed_response.size == 1
    end
  end

  context 'GET /api/tasks/:id' do
    should 'return task info' do
      log_in(@user)
      get "/api/tasks/#{@task.id}"
      assert_status(200)
      assert_action_show(@task, [:id, :radar_id, :status, :results, :messages, :created_at, :updated_at])
    end

    should 'return error when task is missing' do
      log_in(@user)
      get '/api/tasks/0'
      assert_status(404)
      assert parsed_response.include?(:error)
    end
  end

  context 'POST /api/tasks' do
    should 'return task info' do
      log_in(@user)
      post '/api/tasks', { radar_id: @radar.id, frame: @task.frame }.to_json
      assert_status(201)
      assert parsed_response.include?(:id)
    end

    should 'return error when Radar ID is wrong' do
      log_in(@user)
      post '/api/tasks', { radar_id: 0, frame: @task.frame }.to_json
      assert_status(404)
      assert parsed_response.include?(:error)
    end

    should 'return error when frame is wrong' do
      log_in(@user)
      post '/api/tasks', { radar_id: @radar.id, frame: [['o']] }.to_json
      assert_status(422)
      assert parsed_response.include?(:error)
    end
  end

  context 'work with user area without token' do
    should 'return error' do
      get '/api/tasks'
      assert_status(403)
      assert parsed_response[:error] == 'Forbidden'
    end
  end
end
