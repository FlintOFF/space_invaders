module Radar
  class DetectTargetsJob < ApplicationJob
    queue_as :default

    def perform(task_id:)
      DetectBaseCommand.new(task_id: task_id).call
    end
  end
end
