module AtrApi::V1::Entities
  class Target < Grape::Entity
    format_with(:iso_timestamp) { |dt| dt.iso8601 }

    expose :id
    expose :radar_id
    expose :title
    expose :description
    expose :kind
    expose :frame
    with_options(format_with: :iso_timestamp) do
      expose :created_at
      expose :updated_at
    end
  end
end
