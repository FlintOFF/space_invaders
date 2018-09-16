require 'test_helper'

class V1::AdminUsersTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    setup_headers
    @admin = FactoryBot.create(:user, admin: true)
    @user = FactoryBot.create(:user)
  end

  context 'GET /api/admin/users' do
    should 'return list of users' do
      log_in(@admin)
      get '/api/admin/users'
      assert_status(200)
      assert parsed_response.size == 2
    end
  end

  context 'GET /api/admin/users/:id' do
    should 'return user info' do
      log_in(@admin)
      get "/api/admin/users/#{@user.id}"
      assert_status(200)
      assert_action_show(@user, [:id, :email, :admin, :created_at, :updated_at])
    end

    should 'return error when user is missing' do
      log_in(@admin)
      get '/api/admin/users/0'
      assert_status(404)
      assert parsed_response.include?(:error)
    end
  end

  context 'POST /api/admin/users' do
    should 'return user info' do
      log_in(@admin)
      post '/api/admin/users', FactoryBot.build(:user).attributes.deep_symbolize_keys!.merge({ password: '12345678' }).to_json
      assert_status(201)
      assert_action_show(User.find(parsed_response[:id]), [:id, :email, :admin, :created_at, :updated_at])
    end
  end

  context 'PUT /api/admin/users/:id' do
    should 'return user info' do
      log_in(@admin)
      put "/api/admin/users/#{@user.id}", { admin: true }.to_json
      assert_status(200)
      assert_action_show(@user.reload, [:id, :email, :admin, :created_at, :updated_at])
    end
  end

  context 'DELETE /api/admin/users/:id' do
    should 'return successful' do
      log_in(@admin)
      delete "/api/admin/users/#{@user.id}"
      assert_status(200)
      assert parsed_response.include?(:message)
      assert parsed_response[:message] == 'successful'
    end
  end

  context 'work with admin area as the regular user' do
    should 'return error' do
      log_in
      delete "/api/admin/users/#{@user.id}"
      assert_status(403)
      assert parsed_response[:error] == 'Forbidden'
    end
  end
end
