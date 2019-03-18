require 'rails_helper'

RSpec.describe User, type: :model do
  
  it 'creates an user from oauth credential and email' do 
    auth = OmniAuth.config.mock_auth[:github]
    email = 'test@test.com'
    user  = User.create_with_omniauth(auth,email)
    expect(user.persisted?).to be == true
    expect(user.github_oauth_token).to be == auth.credentials.token
  end

  it "is not valid without email" do
    user = User.new
    expect(user).to_not be_valid
  end
end
