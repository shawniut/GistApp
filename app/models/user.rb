class User < ApplicationRecord
  validates_presence_of :email
  def self.create_with_omniauth(auth,email)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.email = email
      user.name = auth["info"]["name"]
      user.github_oauth_token = auth.credentials["token"]
    end
  end
end
