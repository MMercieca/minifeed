class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    user = User.find_by(email: email)
    if !user
      user = User.create!(
        email: email,
        name: auth["info"]["name"],
        uid: auth["uid"],
        provider: auth["provider"]
      )
    end
    
    user.remember_me = true
    sign_in(:user, user)

    redirect_to after_sign_in_path_for(user)
  end
end
