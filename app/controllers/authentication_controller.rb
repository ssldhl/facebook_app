class AuthenticationController < ApplicationController
  def create
    authentication = Authentication.omniauth(env['omniauth.auth'])
    session[:authentication_id] = authentication.id
    redirect_to root_url
  end

  def destroy
    session[:authentication_id] = nil
  end
end
