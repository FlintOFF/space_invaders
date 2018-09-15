require 'test_helper'

class V1::TasksTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    @user = FactoryBot.create(:user)
    @radar = FactoryBot.create(:radar)
    @target = FactoryBot.create(:target, radar: @radar)
    @task = FactoryBot.create(:task, user: @user, radar: @radar)

    log_in(@user)
  end

  context 'GET /tasks' do
    should 'return list of tasks' do
      get '/tasks'
      assert_status(200)
      assert parsed_response.size == 1
    end
  end

  context 'GET /tasks/:id' do
    should 'return task info' do
      get "/tasks/#{@task.id}"
      assert_status(200)
      assert_action_show(@task, [:id, :radar_id, :status, :results, :messages, :created_at, :updated_at])
    end

    should 'return error when task is missing' do
      get '/tasks/0'
      assert_status(404)
      assert parsed_response.include?(:error)
    end
  end

  context 'POST /tasks' do
    should 'return task info' do
      post '/tasks', { radar_id: @radar.id, frame: @task.frame }.to_json
      assert_status(201)
      assert parsed_response.include?(:id)
    end

    should 'return error when Radar ID is wrong' do
      post '/tasks', { radar_id: 0, frame: @task.frame }.to_json
      assert_status(404)
      assert parsed_response.include?(:error)
    end

    should 'return error when frame is wrong' do
      post '/tasks', { radar_id: @radar.id, frame: [['o']] }.to_json
      assert_status(422)
      assert parsed_response.include?(:error)
    end
  end
end
