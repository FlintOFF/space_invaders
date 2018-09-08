
class DetectBaseCommand
  prepend SimpleCommand

  def initialize(task_id:)
    @task_id = task_id
  end

  def call
    #TODO: need todo it!!!!
    #
    #
    #
    # task = Task.find_by(id: task_id)
    # return unless task || task.pending?
    # task.update(status: :working)
    #
    # out = []
    # targets = task.radar.targets
    #
    # if targets.size.zero?
    #   task.update(status: :failed, messages: ["Couldn't find any records of targets for detect"])
    #   return
    # end
    #
    # targets.each do |target|
    #   command = DetectTargetCommand.new(
    #     radar_frame: task.frame,
    #     target_frame: target.frame,
    #     configs: { minimum_match: task.minimum_match }
    #   ).call
    #
    #   if command.success?
    #     command.result.to_a.each do |result|
    #       out << result.merge({ target_id: target.id, errors: command.errors })
    #     end
    #   else
    #     out << { target_id: target.id, errors: command.errors }
    #   end
    #
    # end
    #
    # task.update(status: :complete, results: out)
  end
end

