class PatreonController < ApplicationController
  def patreon_callback
    redirect_uri = "http://localhost:3000/patreon_callback"
    oauth_client = Patreon::OAuth.new(ENV.fetch('PATREON_CLIENT_ID'), ENV.fetch('PATREON_SECRET_KEY'))
    tokens = oauth_client.get_tokens(params[:code], redirect_uri)
    access_token = tokens['access_token']

    api_client = Patreon::API.new(access_token)
    email = api_client.fetch_user().data.email

    # TODOMPM - make this work with google
    user = User.find_by(email: email)
    if !user
      user = User.create(email: email, provider: 'patreon')
    end

    sign_in(:user, user)
    redirect_to after_sign_in_path_for(user)
  end

  def patreon_launch
    login_url = "https://www.patreon.com/oauth2/authorize" \
      "?response_type=code" \
      "&client_id=#{ENV.fetch('PATREON_CLIENT_ID')}" \
      "&redirect_uri=http://localhost:3000/patreon_callback" \
      "&scopes=identity.email,identity.memberships"
    redirect_to login_url, allow_other_host: true
  end
end