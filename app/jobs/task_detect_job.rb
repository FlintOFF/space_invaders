class TaskDetectJob < ApplicationJob
  queue_as :default

  def perform(task_id:)
    TaskDetectService.new(Task.find(task_id)).perform
  end
end
