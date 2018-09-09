FactoryBot.define do
  factory :radar do
    title { 'Radar #1' }
    description { 'Description for radar' }
    frame_height { 2 }
    frame_width { 2 }
    frame_symbols { ['-', 'o'] }
  end
end