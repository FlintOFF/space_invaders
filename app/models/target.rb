class Target < ApplicationRecord
  include ValidateFrameSymbols

  belongs_to :radar

  enum kind: { enemy: 0, friend: 1 }

  validates :frame, presence: true
  validate :validate_frame_resolution

  def validate_frame_resolution
    return if radar.nil?
    frame_info = FrameService.info(frame)
    unless radar.frame_height >= frame_info[:frame_height] && radar.frame_width >= frame_info[:frame_width]
      errors.add(:frame, 'frame resolution must be be greater or identical to the resolution of radar frame')
    end
  end
end
