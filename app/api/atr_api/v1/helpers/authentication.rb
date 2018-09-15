module AtrApi::V1::Helpers::Authentication
  extend Grape::API::Helpers

  def only_admin!
    error!('Forbidden', 403) unless current_user.admin?
  end
end