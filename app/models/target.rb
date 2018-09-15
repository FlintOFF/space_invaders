class Target < ApplicationRecord
  include ValidateFrameSymbols

  belongs_to :radar

  enum kind: { enemy: 0, friend: 1 }

  validates :frame, presence: true
  validate :validate_frame_resolution

  def validate_frame_resolution
    return if radar.nil?
    unless radar.frame_height >= frame.size && radar.frame_width >= frame.first.try(:size).to_i
      errors.add(:frame, 'frame resolution must be be greater or identical to the resolution of radar frame')
    end
  end
end
