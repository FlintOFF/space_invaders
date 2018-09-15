require 'test_helper'

class TaskTest < ActiveSupport::TestCase

  def setup
    @radar = FactoryBot.create(:radar)
    @target = FactoryBot.create(:target, radar: @radar)
    @task = FactoryBot.create(:task, radar: @radar)
  end

  context 'associations' do
    should belong_to(:user)
    should belong_to(:radar)
  end

  context 'validations' do
    should validate_presence_of(:frame)
  end

  context 'fields' do
    should define_enum_for(:status).with(pending: 0, working: 3, failed: 6, complete: 9)
  end

  context '#validate_frame_resolution' do
    should 'not pass validation' do
      @task.update(frame: @task.frame * 2)
      assert_not @task.valid?
    end

    should 'pass validation' do
      @task.update(frame: @task.frame.reverse)
      assert @task.valid?
    end
  end

  context '#validate_frame_symbols' do
    should 'not pass validation' do
      new_symbol = (SecureRandom.alphanumeric(@radar.frame_symbols.size * 2).split('') - @radar.frame_symbols).first
      @task.frame[0][0] = new_symbol
      @task.save
      assert_not @task.valid?
    end

    should 'pass validation' do
      @task.update(frame: @task.frame.map { |a| Array.new(a.size, @radar.frame_symbols.first) })
      assert @task.valid?
    end
  end

  context '#validate_targets_count' do
    should 'not pass validation' do
      Target.destroy_all
      @task.save
      assert_not @task.valid?
    end

    should 'pass validation' do
      @task.save
      assert @task.valid?
    end
  end

  context '#minimum_match' do
    should 'been in range 0-100' do
      assert (0..100).include?(@task.minimum_match)
    end
  end
end
