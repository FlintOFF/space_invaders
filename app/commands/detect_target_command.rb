require 'matrix'

class DetectTargetCommand
  prepend SimpleCommand

  def initialize(radar_frame: [], target_frame: [], configs: { minimum_match: 80 })
    @radar_frame = radar_frame
    @target_frame = target_frame
    @configs = configs

    @radar_frame_height = @radar_frame.try(:size).to_i
    @radar_frame_width = @radar_frame.first.try(:size).to_i
    @target_frame_height = @target_frame.try(:size).to_i
    @target_frame_width = @target_frame.first.try(:size).to_i
  end

  def call
    out = []

    unless validate_frame_size
      errors.add(:radar, 'Wrong frames size. Size can\'t be a zero and radar frame must be the same or bigger than the target frame')
    end

    return nil unless errors.size.zero?

    generate_compare_jobs.each do |compare_job|
      radar_sub_frame = cut_frame(@radar_frame, *compare_job[:radar])
      target_sub_frame = cut_frame(@target_frame, *compare_job[:target])
      percent = compare_frames(radar_sub_frame, target_sub_frame)
      overlap_percent = overlap(@target_frame, target_sub_frame)

      if percent >= @configs[:minimum_match]
        out << { position: compare_job[:radar], percent: percent, overlap_percent: overlap_percent }
      end
    end

    out
  end

  def generate_compare_jobs
    target_half_height = (@target_frame_height / 2).round
    target_half_width = (@target_frame_width / 2).round
    out = []

    #todo: remove NEXTs

    (0..@radar_frame_width).each do |c|
      (0..@radar_frame_height).each do |r|
        # at the ends of radar frame
        if @radar_frame_height - r < @target_frame_height && @radar_frame_width - c < @target_frame_width
          next if @radar_frame_height - r < target_half_height || @radar_frame_width - c < target_half_width # next if rows/columns less that 50% of search matrix
          out << { radar: [r, @radar_frame_height - r, c, @radar_frame_width - c], target: [0, @radar_frame_height - r, 0, @radar_frame_width - c] }
        elsif @radar_frame_height - r < @target_frame_height
          next if @radar_frame_height - r < target_half_height # next if rows/columns less that 50% of search matrix
          out << { radar: [r, @radar_frame_height - r, c, @target_frame_width], target: [0, @radar_frame_height - r, 0, @target_frame_width] }
        elsif @radar_frame_width - c < @target_frame_width
          next if @radar_frame_width - c < target_half_width # next if rows/columns less that 50% of search matrix
          out << { radar: [r, @target_frame_height, c, @radar_frame_width - c], target: [0, @target_frame_height, 0, @radar_frame_width - c] }
        else
          # at a middle of the radar frame
          out << { radar: [r, @target_frame_height, c, @target_frame_width], target: [0, @target_frame_height, 0, @target_frame_width] }
        end

        # at a start of radar frame
        if !(0..target_half_height-1).include?(r) && (0..target_half_width-1).include?(c)
          out << { radar: [r, @target_frame_height, 0, target_half_width + c], target: [0, @target_frame_height, target_half_width - c, target_half_width + c] }
        elsif (0..target_half_height-1).include?(r) && !(0..target_half_width-1).include?(c)
          out << { radar: [0, target_half_height + r, c, @target_frame_width], target: [target_half_height - r, target_half_height + r, 0, @target_frame_width] }
        end
      end
    end
    out
  end

  def compare_frames(base_frame, frame)
    same = base_frame.flatten.zip(frame.flatten).select { |a, b| a == b }.size
    (same.to_f / base_frame.flatten.size * 100).round
  end

  def overlap(base_frame, frame)
    (((frame.size.to_f * frame.first.size) / (base_frame.size * base_frame.first.size)) * 100).round
  end

  def cut_frame(frame, x_start, x_size, y_start, y_size)
    Matrix[*frame].minor(x_start, x_size, y_start, y_size).to_a
  end

  def validate_frame_size
    @target_frame_height > 0 &&
    @target_frame_width > 0 &&
    @radar_frame_height >= @target_frame_height &&
    @radar_frame_width >= @target_frame_width
  end
end

