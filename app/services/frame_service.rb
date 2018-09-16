class FrameService
  def self.median_filter(frame, radius=3)
    radius += 1 if radius.even?
    filtered = []

    height = frame.size.to_i
    width = frame.first.size.to_i

    (height).times do |y|
      (width).times do |x|

        window = []
        (y - radius).upto(y + radius).each do |win_y|
          (x - radius).upto(x + radius).each do |win_x|
            win_x = 0 if win_x < 0
            win_y = 0 if win_y < 0
            win_x = width-1 if win_x >= width
            win_y = height-1 if win_y >= height
            window << frame[win_y][win_x]
          end
        end

        # median
        filtered[y] = [] if filtered[y].nil?
        filtered[y][x] = window.sort[window.length / 2]
      end
    end

    filtered
  end

  def self.load_from_file(file_path)
    a = []
    File.open(file_path) do |f|
      f.each_line do |line|
        l = line.gsub("\n", '')
        a << l.split('')
      end
    end
    a
  end

  def self.info(frame)
    {
      frame_height: frame.size,
      frame_width: frame.first.try(:size).to_i,
      frame_symbols: frame.flatten.uniq
    }
  end
end