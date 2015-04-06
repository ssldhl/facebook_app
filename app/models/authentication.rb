class Authentication < ActiveRecord::Base
  belongs_to :user

  def self.omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      self.provider = auth.provider
      self.uid = auth.uid
      self.name = auth.info.name
      self.image = auth.info.image
      self.token = auth.credentials.token
      self.expires_at = Time.at(auth.credentials.expires_at)
      self.user_id = current_user.id
      save!
    end
  end
end
