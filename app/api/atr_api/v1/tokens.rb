module AtrApi::V1
  class Tokens < AtrApi::V1::Root
    resource :tokens do
      desc 'Create token'
      params do
        requires :email, allow_blank: false, regexp: /.+@.+/, desc: 'Email.'
        requires :password, allow_blank: false, desc: 'Password.'
      end
      post do
        user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
        error!('403 Forbidden', 403) unless user
        { token: Knock::AuthToken.new(payload: { sub: user.id }).token }
      end
    end
  end
end
