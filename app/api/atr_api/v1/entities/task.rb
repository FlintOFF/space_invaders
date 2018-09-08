module AtrApi::V1::Entities
  class Task < Grape::Entity
    format_with(:iso_timestamp) { |dt| dt.iso8601 }

    expose :id
    expose :radar_id
    expose :status
    expose :results
    expose :messages
    with_options(format_with: :iso_timestamp) do
      expose :created_at
      expose :updated_at
    end
  end
end
