FactoryGirl.define do
  factory :valid_user, class: User do
    name               { "Valid User" }
    email              { "testuser@test.com" }
    github_oauth_token { "4acf4b30d47d332a7bc117086a754b2441a43f4b" }
  end

  factory :invalid_user, class: User do
    name               { "Invalid User" }
    email              { "testuser@test.com" }
    github_oauth_token { "dfsdfsdfgsdgsdfgsd" }
  end
end