class Subscription < ActiveRecord::Base
  belongs_to :user

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(email:description, plan: plan, card: stripe_customer_token, description:description)
      self.stripe_customer_token = customer.id
      self.description = description
      self.user_id = user_id
      self.plan = plan
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, 'There was a problem with your credit card.'
  end

  def update_with_payment(subscription_params, stripe_token)
    if valid?
      customer = Stripe::Customer.retrieve(stripe_token)
      customer.email = subscription_params[:description]
      customer.plan = subscription_params[:plan]
      customer.card = subscription_params[:stripe_customer_token]
      customer.description = subscription_params[:description]
      customer.save
      subscription_params[:stripe_customer_token] = customer.id
      update(subscription_params)
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while updating customer: #{e.message}"
    errors.add :base, 'There was a problem with your credit card.'
  end
end
