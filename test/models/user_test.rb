require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context 'associations' do
    should have_many(:tasks)
  end

  context 'validations' do
    should validate_presence_of(:email)
    should allow_value("user@example.com").for(:email)
    should_not allow_value("not-an-email").for(:email)
  end

  context 'authentications' do
    should have_secure_password
  end
end
