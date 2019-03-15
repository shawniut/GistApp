FactoryGirl.define do
  factory :valid_user, class: User do
    name               { "Valid User" }
    email              { "testuser@test.com" }
    github_oauth_token { "9df8065450461e4f317aef6391bc90bc31d7db0a" }
  end

  factory :invalid_user, class: User do
    name               { "Invalid User" }
    email              { "testuser@test.com" }
    github_oauth_token { "dfsdfsdfgsdgsdfgsd" }
  end
end