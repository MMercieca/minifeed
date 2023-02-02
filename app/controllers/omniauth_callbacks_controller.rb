class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    user_auth = UserAuthentication.find_by(provider: 'google', uid: auth['uid'], email: auth['info']['email'])
    if user_auth.nil?
      user = User.create!(
        email: auth['info']['email'],
        name: auth['info']['name'],
        provider: auth['provider']
      )

      user_auth = UserAuthentication.create!(
        user: user,
        provider: 'google',
        uid: auth['uid'],
        email: auth['info']['email']
      )
    end

    user = user_auth.user
    user.name ||= auth["info"]["name"]
    user.save!

    user.remember_me = true
    sign_in(:user, user)

    redirect_to after_sign_in_path_for(user)
  end
end
