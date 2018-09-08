class Target < ApplicationRecord
  belongs_to :radar

  enum kind: { enemy: 0, friend: 1 }

  validates :frame, presence: true #todo: type must be an array
  validate :validate_frame_resolution, :validate_frame_symbols

  def validate_frame_resolution
    unless radar.frame_height >= frame.size && radar.frame_width >= frame.first.try(:size).to_i
      errors.add(:frame, 'frame resolution must be be greater or identical to the resolution of radar frame')
    end
  end

  def validate_frame_symbols
    #TODO: move to common place for same validations in different models
    unless (frame.flatten.uniq - radar.frame_symbols).size.zero?
      errors.add(:frame, 'frame must contain the same symbols as radar frame')
    end
  end

end
