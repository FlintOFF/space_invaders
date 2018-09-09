module ValidateFrameSymbols
  extend ActiveSupport::Concern

  included do
    validate :validate_frame_symbols

    def validate_frame_symbols
      return if radar.nil?
      unless (frame.flatten.uniq - radar.frame_symbols).size.zero?
        errors.add(:frame, 'frame must contain the same symbols as radar frame')
      end
    end
  end
end
