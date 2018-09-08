module AtrApi::V1::Entities
  class TargetList < Grape::Entity
    expose :id
    expose :radar_id
    expose :title
    expose :kind
  end
end


