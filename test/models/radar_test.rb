require 'test_helper'

class RadarTest < ActiveSupport::TestCase
  context 'associations' do
    should have_many(:targets).dependent(:destroy)
    should have_many(:tasks).dependent(:destroy)
  end

  context 'validations' do
    should validate_presence_of(:title)
    should validate_presence_of(:frame_symbols)
    should validate_presence_of(:frame_height)
    should validate_numericality_of(:frame_height)
    should validate_presence_of(:frame_width)
    should validate_numericality_of(:frame_width)
  end
end
