module AtrApi::V1
  class Radars < AtrApi::V1::Root
    resource :radars do
      desc 'List of radars'
      params do
        use :pagination
      end
      get do
        present Radar.page(params[:page]).per(params[:per_page]), with: Entities::RadarList
      end

      desc 'Show radar'
      params do
        requires :id, type: Integer, desc: 'Radar ID'
      end
      get '/:id' do
        present Radar.find(params[:id]), with: Entities::Radar
      end
    end
  end
end