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
    # {"stripeToken"=>"tok_15mioFCg8s8K6vs1gwSXGVb6"}
    @subscription = Subscription.new(subscription_params)
    if @subscription.save_with_payment
      redirect_to @subscription, :notice => "Thank you for subscribing!"
    else
      render :new
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def subscription_params
    params.require(:subscription).permit(:stripe_customer_token, :plan, :user_id)
  end
end
