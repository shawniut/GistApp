class SessionsController < ApplicationController
  def create 
    auth = request.env["omniauth.auth"]
    github = Github.new oauth_token: auth.credentials['token']
    
    email = github.users.emails.list.first.email   
    
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth,email)
    user.github_oauth_token = auth.credentials['token']
    user.email = email
    user.save!
    session[:user_id] = user.id     
    redirect_to root_url
  end
 
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
