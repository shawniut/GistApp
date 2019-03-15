class User < ApplicationRecord
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.email = "text_#{SecureRandom.hex}@gists.com"
      user.name = auth["info"]["name"]
      user.github_oauth_token = auth.credentials['token']
    end
  end
end
