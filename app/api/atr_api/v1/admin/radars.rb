module AtrApi::V1::Admin
  class Radars < AtrApi::V1::Admin::Root
    resource :radars do
      desc 'Create radar'
      params do
        requires :title, type: String, desc: 'Title.'
        optional :description, type: String, desc: 'Description.'
        requires :frame_height, type: Integer, desc: 'Frame height.'
        requires :frame_width, type: Integer, desc: 'Frame width.'
        requires :frame_symbols, type: Array, desc: 'Frame symbols.'
      end
      post do
        present Radar.create!(declared(params), include_missing: false), with: AtrApi::V1::Entities::Radar
      end

      desc 'Update radar'
      params do
        requires :id, type: Integer, desc: 'Radar ID.'
        optional :title, type: String, desc: 'Title.'
        optional :description, type: String, desc: 'Description.'
        optional :frame_height, type: Integer, desc: 'Frame height.'
        optional :frame_width, type: Integer, desc: 'Frame width.'
        optional :frame_symbols, type: Array, desc: 'Frame symbols.'
      end
      put ':id' do
        present Radar.find(params[:id]).update(declared(params), include_missing: false), with: AtrApi::V1::Entities::Radar
      end

      desc 'Delete radar'
      params do
        requires :id, type: Integer, desc: 'Radar ID.'
      end
      delete ':id' do
        Radar.find(params[:id]).destroy
        { message: 'successful' }
      end
    end
  end
end