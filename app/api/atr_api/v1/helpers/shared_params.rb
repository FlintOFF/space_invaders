module AtrApi::V1::Helpers::SharedParams
  extend Grape::API::Helpers

  params :pagination do
    optional :page, type: Integer
    optional :per_page, type: Integer
  end
end