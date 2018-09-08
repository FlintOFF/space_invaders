class Task < ApplicationRecord
  belongs_to :user
  belongs_to :radar

  enum status: { pending: 0, working: 3, failed: 6, complete: 9 }


  validates :frame, presence: true
  validate :validate_frame_resolution, :validate_frame_symbols

  # validates :coordinates, presence: true


  def validate_frame_resolution
    unless radar.frame_height == frame.size && radar.frame_width == frame.first.try(:size).to_i
      errors.add(:frame, 'frame resolution must be same as resolution of radar frame')
    end
  end

  def validate_frame_symbols
    unless (frame.flatten.uniq - radar.frame_symbols).size.zero?
      errors.add(:frame, 'frame must contain the same symbols as radar frame')
    end
  end

  def minimum_match
    80
  end

end
