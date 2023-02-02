class PatreonController < ApplicationController
  def patreon_callback
    redirect_uri = ENV.fetch('PATREON_REDIRECT')
    oauth_client = Patreon::OAuth.new(ENV.fetch('PATREON_CLIENT_ID'), ENV.fetch('PATREON_SECRET_KEY'))
    tokens = oauth_client.get_tokens(params[:code], redirect_uri)
    access_token = tokens['access_token']

    api_client = Patreon::API.new(access_token)
    user = api_client.fetch_user()
    email = user.data.email
 
    user_auth = UserAuthentication.find_by(
      email: email,
      provider: 'patreon'
    )

    if user_auth.nil?
      user = User.find_by(email: email)

      if user.nil?
        user = User.create!(
          email: email,
          provider: 'patreon',
          name: user.data.full_name
        )
      end

      user_auth = UserAuthentication.create!(
        user: user,
        provider: 'patreon',
        email: email
      )
    end

    user = user_auth.user

    user.remember_me = true
    session['patreon_access_token'] = access_token
    sign_in(:user, user)

    redirect_to after_sign_in_path_for(user)
  end

  def patreon_launch
    login_url = "https://www.patreon.com/oauth2/authorize" \
      "?response_type=code" \
      "&client_id=#{ENV.fetch('PATREON_CLIENT_ID')}" \
      "&redirect_uri=#{ENV.fetch('PATREON_REDIRECT')}"
    redirect_to login_url, allow_other_host: true
  end
end