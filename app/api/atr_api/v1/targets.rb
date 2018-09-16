module AtrApi::V1
  class Targets < AtrApi::V1::Root
    use Grape::Knock::Authenticable

    namespace :targets do
      desc 'List of targets' do
        success Entities::TargetList
      end
      params do
        use :pagination
      end
      get do
        present Target.page(params[:page]).per(params[:per_page]), with: Entities::TargetList
      end

      desc 'Show target' do
        success Entities::Target
      end
      params do
        requires :id, type: Integer, desc: 'Target ID'
      end
      get '/:id' do
        present Target.find(params[:id]), with: Entities::Target
      end
    end
  end
end