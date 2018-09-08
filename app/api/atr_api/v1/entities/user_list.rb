module AtrApi::V1::Entities
  class UserList < Grape::Entity
    expose :id
    expose :email
    expose :admin
  end
end
