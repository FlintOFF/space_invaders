module AtrApi::V1::Admin
  class Targets < AtrApi::V1::Admin::Root
    namespace :targets do
      desc 'Create target' do
        success AtrApi::V1::Entities::Target
      end
      params do
        requires :radar_id, type: Integer, desc: 'Radar ID.'
        requires :title, type: String, desc: 'Title.'
        optional :description, type: String, desc: 'Description.'
        requires :kind, type: Symbol, values: [:enemy, :friend], desc: 'Kind.'
        requires :frame, type: Array[Array], desc: 'Frame.'
      end
      post do
        target = Radar.find(params[:radar_id]).targets.create!(declared(params, include_missing: false))
        present target, with: AtrApi::V1::Entities::Target
      end

      desc 'Update target' do
        success AtrApi::V1::Entities::Target
      end
      params do
        requires :id, type: Integer, desc: 'Target ID.'
        optional :title, type: String, desc: 'Title.'
        optional :description, type: String, desc: 'Description.'
        optional :kind, values: [:enemy, :friend], desc: 'Kind.'
        optional :frame, type: Array[Array], desc: 'Frame.'
      end
      put ':id' do
        target = Target.find(params[:id])
        target.update(declared(params, include_missing: false))
        present target, with: AtrApi::V1::Entities::Target
      end

      desc 'Delete target'
      params do
        requires :id, type: Integer, desc: 'Target ID.'
      end
      delete ':id' do
        Target.find(params[:id]).destroy
        { message: 'successful' }
      end
    end
  end
end
