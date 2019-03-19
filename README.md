# README


Live APP LINK : https://gistsapp.herokuapp.com/

Following Stories are implemented:

1)As a github user, I want to be able to list all of my private gists, so that I can see them all

2)As a github user, I want to create a new private gist, so that I can add a new one

3)As a github user, I want to be able to edit one of my private gists, so that I can change the content

4)As a github user, I want to be able to delete one of my private gists, so that I can remove it

5)As a github user, I want to see an audit history of actions I have performed on my gists, so that I can see a record of what I changed and when

6) As a github user, I want to see which of my gists I have starred in Github, so that I know which are my favorites 

**As a github user, I want to create multiple private gists at one time, so I don't have to do them one at a time
Only backend of this story is implemented


To pass the sessions_controller specs it needs to set a real token in the mockauth hash in rails_helper.rb

OmniAuth.config.test_mode = true
  omniauth_hash = OmniAuth::AuthHash.new(
    credentials:{
        token:'9a1a45e4c1eaf0292ddcee0f6d49601b67c61869'
      },
      info:{name:'Test User'},
      provider:'github',
      uid:'125544566'
    )
