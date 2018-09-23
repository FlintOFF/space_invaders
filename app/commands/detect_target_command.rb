class DetectTargetCommand
  prepend SimpleCommand

  def initialize(radar_frame: [], target_frame: [], configs: {})
    @radar_frame = BinaryImageToolset::Frame.new(radar_frame)
    @target_frame = BinaryImageToolset::Frame.new(target_frame)
    @configs = configs
  end

  def call
    validators
    return nil unless errors.size.zero?
    @radar_frame.find(@target_frame, :standard, @configs)
  end

  def validators
    unless validate_frame_size
      errors.add(:radar, 'Wrong frames size. Size can\'t be a zero and radar frame must be the same or bigger than the target frame')
    end
  end

  def validate_frame_size
    @target_frame.height > 0 &&
    @target_frame.width > 0 &&
    @radar_frame.height >= @target_frame.height &&
    @radar_frame.width >= @target_frame.width
  end
end
