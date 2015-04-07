class Authentication < ActiveRecord::Base
  belongs_to :user

  def omniauth
    self.provider = provider
    self.uid = uid
    self.name = name
    self.image = image
    self.token = token
    self.expires_at = expires_at
    self.user_id = user_id
    save!
    self.id
  rescue Exception => e
    logger.error "Facebook error while authenticating: #{e.message}"
    errors.add :base, 'There was a problem authenticating with facebook.'
  end
end
