require 'test_helper'

class V1::TokensTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def setup
    @password = '1234567890'
    @user = FactoryBot.create(:user, password: @password)
  end

  context 'POST /api/tokens' do
    should 'return token' do
      post '/api/tokens', { email: @user.email, password: @user.password }
      assert parsed_response.include?(:token)
      assert_status(201)
    end

    should 'return error when password is wrong' do
      post '/api/tokens', { email: @user.email, password: 'wrong_password' }
      assert parsed_response.include?(:error)
      assert_status(403)
    end

    should 'return error when email is wrong' do
      post '/api/tokens', { email: 'wrong@test.com', password: @user.password }
      assert parsed_response.include?(:error)
      assert_status(403)
    end
  end
end
