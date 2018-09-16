module AtrApi
  class Root < Grape::API
    format :json

    rescue_from Grape::Knock::ForbiddenError do
      error!('Forbidden', 403)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      error!(e.message, 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error!(e.message, 422)
    end

    mount AtrApi::V1::Root
    add_swagger_documentation
  end
end