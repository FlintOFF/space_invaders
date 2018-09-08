module AtrApi::V1::Entities
  class TaskList < Grape::Entity
    expose :id
    expose :radar_id
    expose :status
  end
end
