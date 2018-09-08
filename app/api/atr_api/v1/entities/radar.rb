module AtrApi::V1::Entities
  class Radar < Grape::Entity
    format_with(:iso_timestamp) { |dt| dt.iso8601 }

    expose :id
    expose :title
    expose :description
    expose :frame_height
    expose :frame_width
    expose :frame_symbols
    with_options(format_with: :iso_timestamp) do
      expose :created_at
      expose :updated_at
    end
  end
end
