class PatreonController < ApplicationController
  def patreon_callback
    redirect_uri = "http://localhost:3000/patreon_callback"
    oauth_client = Patreon::OAuth.new(ENV.fetch('PATREON_CLIENT_ID'), ENV.fetch('PATREON_SECRET_KEY'))
    tokens = oauth_client.get_tokens(params[:code], redirect_uri)
    access_token = tokens['access_token']

    api_client = Patreon::API.new(access_token)
    user = api_client.fetch_user()
    campaign = api_client.fetch_campaign_and_patrons()
    binding.pry
    puts
    # user_response uses [json-api-vanilla](https://github.com/trainline/json-api-vanilla) for easy usage
    render plain: api_client.fetch_user().data
  end

  def patreon_launch
    login_url = "https://www.patreon.com/oauth2/authorize" \
      "?response_type=code" \
      "&client_id=#{ENV.fetch('PATREON_CLIENT_ID')}" \
      "&redirect_uri=http://localhost:3000/patreon_callback"
    redirect_to login_url, allow_other_host: true
  end
end