module AtrApi::V1::Admin
  class Users < AtrApi::V1::Admin::Root
    resource :users do
      desc 'List of users' do
        success AtrApi::V1::Entities::UserList
      end
      params do
        use :pagination
      end
      get do
        present User.page(params[:page]).per(params[:per_page]), with: AtrApi::V1::Entities::UserList
      end

      desc 'Show user' do
        success AtrApi::V1::Entities::User
      end
      params do
        requires :id, type: Integer, desc: 'User ID'
      end
      get '/:id' do
        present User.find(params[:id]), with: AtrApi::V1::Entities::User
      end

      desc 'Create user' do
        success AtrApi::V1::Entities::User
      end
      params do
        requires :email, allow_blank: false, regexp: /.+@.+/, desc: 'Email.'
        requires :password, allow_blank: false, desc: 'Password.'
        optional :admin, type: Boolean, default: false, desc: 'Is admin?.'
      end
      post do
        present User.create!(declared(params, include_missing: false)), with: AtrApi::V1::Entities::User
      end

      desc 'Update user' do
        success AtrApi::V1::Entities::User
      end
      params do
        requires :id, type: Integer, desc: 'User ID.'
        optional :email, allow_blank: false, regexp: /.+@.+/, desc: 'Email.'
        optional :admin, type: Boolean, default: false, desc: 'Is admin?.'
      end
      put ':id' do
        user = User.find(params[:id])
        user.update(declared(params, include_missing: false))
        present user, with: AtrApi::V1::Entities::User
      end

      desc 'Delete user'
      params do
        requires :id, type: Integer, desc: 'User ID.'
      end
      delete ':id' do
        User.find(params[:id]).destroy
        { message: 'successful' }
      end
    end
  end
end