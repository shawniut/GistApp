# README


Live APP LINK : https://gistsapp.herokuapp.com/

##Following Stories are implemented:

1)As a github user, I want to be able to list all of my private gists, so that I can see them all

2)As a github user, I want to create a new private gist, so that I can add a new one

3)As a github user, I want to be able to edit one of my private gists, so that I can change the content

4)As a github user, I want to be able to delete one of my private gists, so that I can remove it

5)As a github user, I want to see an audit history of actions I have performed on my gists, so that I can see a record of what I changed and when

6) As a github user, I want to see which of my gists I have starred in Github, so that I know which are my favorites 

**As a github user, I want to create multiple private gists at one time, so I don't have to do them one at a time
Only backend of this story is implemented


To pass the specs please set a real TOKEN in the omniauth_hash  in rails_helper.rb and /factories/user.rb
```
OmniAuth.config.test_mode = true
  omniauth_hash = OmniAuth::AuthHash.new(
    credentials:{
        token:'**c13039553fb426c910331dc09fec2e9e040ab4c0**'
      },
      info:{name:'Test User'},
      provider:'github',
      uid:'125544566'
    )
```

```
factory :valid_user, class: User do
  name               { "Valid User" }
  email              { "testuser@test.com" }
  github_oauth_token { "**c13039553fb426c910331dc09fec2e9e040ab4c0**" }
end

```
