class Task < ApplicationRecord
  include ValidateFrameSymbols

  belongs_to :user
  belongs_to :radar

  enum status: { pending: 0, working: 3, failed: 6, complete: 9 }

  validates :frame, presence: true
  validate :validate_frame_resolution, :validate_targets_count

  def minimum_match
    80
  end

  private

  def validate_frame_resolution
    return if radar.nil?
    frame_info = FrameService.info(frame)
    unless radar.frame_height == frame_info[:frame_height] && radar.frame_width == frame_info[:frame_width]
      errors.add(:frame, 'frame resolution must be same as resolution of radar frame')
    end
  end

  def validate_targets_count
    return if radar.nil?
    if radar.targets.size.zero?
      errors.add(:task, "Couldn't find any records of targets for detect")
    end
  end
end
