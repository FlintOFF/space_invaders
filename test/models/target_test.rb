require 'test_helper'

class TargetTest < ActiveSupport::TestCase
  def setup
    @radar = FactoryBot.create(:radar)
    @target = FactoryBot.create(:target, radar: @radar)
  end

  context 'associations' do
    should belong_to(:radar)
  end

  context 'validations' do
    should validate_presence_of(:frame)
  end

  context 'fields' do
    should define_enum_for(:kind) #TODO: enum kind: { enemy: 0, friend: 1 }
  end

  context '#validate_frame_resolution' do
    should 'not pass validation when height and width more than radar frame' do
      @target.update(frame: Array.new(@radar.frame_height + 1) { Array.new(@radar.frame_width + 1, @radar.frame_symbols.first) })
      assert_not @target.valid?
    end

    should 'not pass validation when height more than radar frame' do
      @target.update(frame: Array.new(@radar.frame_height + 1) { Array.new(@radar.frame_width, @radar.frame_symbols.first) })
      assert_not @target.valid?
    end

    should 'not pass validation when width more than radar frame' do
      @target.update(frame: Array.new(@radar.frame_height) { Array.new(@radar.frame_width + 1, @radar.frame_symbols.first) })
      assert_not @target.valid?
    end

    should 'pass validation' do
      @target.update(frame: Array.new(@radar.frame_height) { Array.new(@radar.frame_width, @radar.frame_symbols.first) })
      assert @target.valid?
    end
  end

  context '#validate_frame_symbols' do
    should 'not pass validation' do
      new_symbol = (SecureRandom.alphanumeric(@radar.frame_symbols.size * 2).split('') - @radar.frame_symbols).first
      @target.frame[0][0] = new_symbol
      @target.save
      assert_not @target.valid?
    end

    should 'pass validation' do
      @target.update(frame: @target.frame.map { |a| Array.new(a.size, @radar.frame_symbols.first) })
      assert @target.valid?
    end
  end
end
