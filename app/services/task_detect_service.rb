class TaskDetectService
  def initialize(task)
    @task = task
    @out = []
  end

  def perform
    return false unless @task.pending?
    @task.update(status: :working)
    find_targets
    find_unknown_targets
    @task.update(status: :complete, results: @out)
    true
  end

  private

  def find_targets
    @task.radar.targets.each do |target|
      command = DetectTargetCommand.new(
        radar_frame: @task.frame,
        target_frame: target.frame,
        configs: { min_match: @task.minimum_match }
      ).call

      if command.success?
        command.result.to_a.each do |result|
          @out << result.merge({ target_id: target.id, errors: command.errors })
        end
      else
        @out << { target_id: target.id, errors: command.errors }
      end
    end
  end

  def find_unknown_targets
    #fill found targets to zeros
    #need to find zero symbol
    #use filter
    #found nonzero sections
  end
end