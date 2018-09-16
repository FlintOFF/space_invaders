namespace :tasks do
  desc 'Handle all pending tasks'
  task handle: :environment do
    Task.pending.ids.each do |task_id|
      TaskDetectJob.perform_now(task_id: task_id)
    end
  end
end
