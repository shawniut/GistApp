FactoryGirl.define do
  factory :valid_user, class: User do
    name               { "Valid User" }
    email              { "testuser@test.com" }
    github_oauth_token { "c13039553fb426c910331dc09fec2e9e040ab4c0" }
  end

  factory :invalid_user, class: User do
    name               { "Invalid User" }
    email              { "testuser@test.com" }
    github_oauth_token { "dfsdfsdfgsdgsdfgsd" }
  end
end