class FrameService
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