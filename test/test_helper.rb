ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def app
    Rails.application
  end

  def parsed_response
    JSON.parse(last_response.body, { symbolize_names: true } )
  end

  def assert_status(exp_status)
    assert_equal(exp_status, last_response.status)
  end

  def log_in(user = nil)
    user = FactoryBot.create(:user) unless user
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    header 'Authorization', "Bearer #{token}"
  end

  def assert_action_show(obj, expected_keys)
    assert parsed_response.keys - expected_keys == []

    obj.attributes.deep_symbolize_keys!.each do |key, value|
      next unless expected_keys.include?(key)
      if [:created_at, :updated_at].include?(key)
        assert parsed_response[key] == value.iso8601
      else
        assert parsed_response[key] == value
      end
    end
  end

  def setup_headers
    header 'Content-Type', 'application/json'
  end
end
