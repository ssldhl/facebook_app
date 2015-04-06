class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  # GET /subscriptions/new
  def new
  end

  def show
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create

    case params[:plan_type]
      when 'basic'
        plan_type = 'lead_chicken_social_spy_basic'
      when 'premium'
        plan_type = 'lead_chicken_social_spy_premium'
      else
        plan_type = 'lead_chicken_social_spy_basic'
    end

    params[:subscription] = {
        stripe_customer_token: params[:stripeToken],
        user_id: current_user.id,
        plan: plan_type,
        description: current_user.email
    }

    @subscription = Subscription.new(subscription_params)
    if @subscription.save_with_payment
      redirect_to root_path, :notice => "Thank you for subscribing!"
    else
      render :new, :alert=> errors[:base]?errors[:base]:nil
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def subscription_params
    params.require(:subscription).permit(:stripe_customer_token, :plan, :user_id, :description)
  end
end
