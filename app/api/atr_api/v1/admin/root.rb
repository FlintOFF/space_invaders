module AtrApi::V1::Admin
  class Root < AtrApi::Root
    use Grape::Knock::Authenticable
    helpers AtrApi::V1::Helpers::SharedParams
    helpers AtrApi::V1::Helpers::Authentication

    before do
      only_admin!
    end

    resource :admin do
      mount AtrApi::V1::Admin::Radars
      mount AtrApi::V1::Admin::Targets
      mount AtrApi::V1::Admin::Users
    end
  end
end
