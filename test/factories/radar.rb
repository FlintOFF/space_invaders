FactoryBot.define do
  factory :radar do
    sequence(:title) { |n| "Radar #{n}" }
    description { 'Description for radar' }
    frame_height { 2 }
    frame_width { 2 }
    frame_symbols { %w(- o) }
  end
end