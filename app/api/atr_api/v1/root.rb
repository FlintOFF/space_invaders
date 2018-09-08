module AtrApi::V1
  class Root < AtrApi::Root
    helpers AtrApi::V1::Helpers::SharedParams
    helpers AtrApi::V1::Helpers::Authentication

    # without authentications
    mount AtrApi::V1::Tokens

    # with authentications
    use Grape::Knock::Authenticable
    mount AtrApi::V1::Admin::Root
    mount AtrApi::V1::Tasks
    mount AtrApi::V1::Targets
    mount AtrApi::V1::Radars
  end
end
