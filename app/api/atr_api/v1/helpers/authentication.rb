module AtrApi::V1::Helpers::Authentication
  extend Grape::API::Helpers

  def only_admin!
    error!('Access Denied', 401) unless current_user.admin?
  end
end