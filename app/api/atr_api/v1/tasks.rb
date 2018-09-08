module AtrApi::V1
  class Tasks < AtrApi::V1::Root
    use Grape::Knock::Authenticable

    namespace :tasks do
      desc 'List of tasks'
      params do
        use :pagination
      end
      get do
        present current_user.tasks.page(params[:page]).per(params[:per_page]), with: Entities::TaskList
      end

      desc 'Show task'
      params do
        requires :id, type: Integer, desc: 'Task ID'
      end
      get '/:id' do
        present current_user.tasks.find(params[:id]), with: Entities::Task
      end

      desc 'Create task'
      params do
        requires :radar_id, type: Integer, desc: 'Radar ID.'
        requires :frame, type: Array[Array], desc: 'Radar frame.'
      end
      post do
        task = current_user.tasks.create!(
          frame: params[:frame],
          radar: Radar.find(params[:radar_id])
        )
        DetectTargetsJob.perform_now(task_id: task.id)
        present task.reload, with: Entities::Task
      end
    end
  end
end