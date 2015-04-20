class AuthenticationController < ApplicationController
  before_action :authenticate_user!, :subscribed

  def facebook_auth
  end

  def create
    auth = request.env['omniauth.auth']
    params[:authentication] = {
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name,
        image: auth.info.image,
        token: auth.credentials.token,
        expires_at:Time.at(auth.credentials.expires_at),
        user_id: current_user.id
    }
    returning_user = Authentication.find_by_user_id(current_user.id)
    if returning_user
      authentication = returning_user.update_omniauth(authentication_params)
    else
      @authentication = Authentication.new(authentication_params)
      authentication = @authentication.omniauth
    end
    if authentication
      redirect_to app_path
      session[:authentication_id] = authentication
    else
      render facebook_auth, :alert=> errors[:base]?errors[:base]:nil
    end
  end

  def destroy
    session[:authentication_id] = nil
    redirect_to root_path
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def authentication_params
    params.require(:authentication).permit(:provider, :uid, :name, :image, :token, :expires_at, :user_id)
  end
end
