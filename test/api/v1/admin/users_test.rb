require 'test_helper'

class V1::AdminUsersTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    @admin = FactoryBot.create(:user, admin: true)
    @user = FactoryBot.create(:user)
  end

  context 'GET /admin/users' do
    should 'return list of users' do
      log_in(@admin)
      get '/admin/users'
      assert_status(200)
      assert parsed_response.size == 2
    end
  end

  context 'GET /admin/users/:id' do
    should 'return user info' do
      log_in(@admin)
      get "/admin/users/#{@user.id}"
      assert_status(200)
      assert_action_show(@user, [:id, :email, :admin, :created_at, :updated_at])
    end

    should 'return error when user is missing' do
      log_in(@admin)
      get '/admin/users/0'
      assert_status(404)
      assert parsed_response.include?(:error)
    end
  end

  context 'POST /admin/users' do
    should 'return user info' do
      log_in(@admin)
      post '/admin/users', FactoryBot.build(:user).attributes.deep_symbolize_keys!.merge({ password: '12345678' }).to_json
      assert_status(201)
      assert_action_show(User.find(parsed_response[:id]), [:id, :email, :admin, :created_at, :updated_at])
    end
  end

  context 'PUT /admin/users/:id' do
    should 'return user info' do
      log_in(@admin)
      put "/admin/users/#{@user.id}", { admin: true }.to_json
      assert_status(200)
      assert_action_show(@user.reload, [:id, :email, :admin, :created_at, :updated_at])
    end
  end

  context 'DELETE /admin/users/:id' do
    should 'return successful' do
      log_in(@admin)
      delete "/admin/users/#{@user.id}"
      assert_status(200)
      assert parsed_response.include?(:message)
      assert parsed_response[:message] == 'successful'
    end
  end

  context 'work with admin area as the regular user' do
    should 'return error' do
      log_in
      delete "/admin/users/#{@user.id}"
      assert_status(403)
      assert parsed_response[:error] == 'Forbidden'
    end
  end
end
