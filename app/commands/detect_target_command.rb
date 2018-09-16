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
    @target_half_height = (@target_frame_height / 2).round
    @target_half_width = (@target_frame_width / 2).round
    @compare_jobs = []
    @debug = false
  end

  def call
    validators
    return nil unless errors.size.zero?
    handle
  end

  def validators
    unless validate_frame_size
      errors.add(:radar, 'Wrong frames size. Size can\'t be a zero and radar frame must be the same or bigger than the target frame')
    end
  end

  def handle
    out = []
    generate_compare_jobs
    @compare_jobs.each do |compare_job|
      radar_sub_frame = cut_frame(@radar_frame, compare_job[:radar])
      target_sub_frame = cut_frame(@target_frame, compare_job[:target])
      percent = compare_frames(radar_sub_frame, target_sub_frame)
      overlap_percent = overlap(@target_frame, target_sub_frame)

      if percent >= @configs[:minimum_match]
        h = { position: compare_job[:radar], percent: percent, overlap_percent: overlap_percent }
        h[:debug] = compare_job[:debug] if @debug
        out << h
      end
    end

    out
  end

  def generate_compare_jobs
    gcj_edge_row_up
    gcj_edge_column_left
    gcj_middle
    gcj_edge_column_right
    gcj_edge_row_down
  end

  def gcj_middle
    (0..(@radar_frame_width - @target_frame_width)).each do |c|
      (0..(@radar_frame_height - @target_frame_height)).each do |r|
        @compare_jobs << { radar: [r, @target_frame_height, c, @target_frame_width], target: [0, @target_frame_height, 0, @target_frame_width], debug: __method__ }
      end
    end
  end

  def gcj_edge_row_up
    (0..(@radar_frame_width - @target_frame_width)).each do |c|
      (0..(@target_frame_height - @target_half_height - 1)).each do |r|
        @compare_jobs << { radar: [0, @target_half_height + r, c, @target_frame_width], target: [@target_half_height - r, @target_half_height + r, 0, @target_frame_width], debug: __method__ }
      end
    end
  end

  def gcj_edge_row_down
    (0..(@radar_frame_width - @target_frame_width)).each do |c|
      ((@radar_frame_height - @target_frame_height + 1)..(@radar_frame_height - @target_half_height)).each do |r|
        @compare_jobs << { radar: [r, @radar_frame_height - r, c, @target_frame_width], target: [0, @radar_frame_height - r, 0, @target_frame_width], debug: __method__ }
      end
    end
  end

  def gcj_edge_column_left
    (0..(@target_frame_width - @target_half_width - 1)).each do |c|
      (0..(@radar_frame_height - @target_frame_height)).each do |r|
        @compare_jobs << { radar: [r, @target_frame_height, 0, @target_half_width + c], target: [0, @target_frame_height, @target_half_width - c, @target_half_width + c], debug: __method__ }
      end
    end
  end

  def gcj_edge_column_right
    ((@radar_frame_width - @target_frame_width + 1)..(@radar_frame_width - @target_half_width)).each do |c|
      (0..(@radar_frame_height - @target_frame_height)).each do |r|
        @compare_jobs << { radar: [r, @target_frame_height, c, @radar_frame_width - c], target: [0, @target_frame_height, 0, @radar_frame_width - c], debug: __method__ }
      end
    end
  end

  def compare_frames(base_frame, frame)
    same = base_frame.flatten.zip(frame.flatten).select { |a, b| a == b }.size
    return 0 if base_frame.flatten.size.zero?
    (same.to_f / base_frame.flatten.size * 100).round
  end

  def overlap(base_frame, frame)
    (((frame&.try(:size).to_f * frame.first&.try(:size).to_f) / (base_frame&.try(:size).to_f * base_frame.first&.try(:size).to_f)) * 100).round
  end

  def cut_frame(frame, coordinates)
    Matrix[*frame].minor(*coordinates).to_a
  end

  def validate_frame_size
    @target_frame_height > 0 &&
    @target_frame_width > 0 &&
    @radar_frame_height >= @target_frame_height &&
    @radar_frame_width >= @target_frame_width
  end
end
