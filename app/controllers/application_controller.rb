class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method 'subscribed'

  def after_sign_in_path_for(resource)
    if Subscription.find_by_user_id resource.id
      authenticated_user = Authentication.find_by_user_id resource.id
      if authenticated_user
        if authenticated_user.expires_at > Time.now
          app_path
        else
          auth_facebook_path
        end
      else
        auth_facebook_path
      end
    else
      new_subscription_path
    end
  end

  private

  def subscribed
    unless Subscription.find_by_user_id current_user.id
      flash[:alert] = 'Please subscribe to a plan'
      redirect_to new_subscription_path
    end
  end

end
