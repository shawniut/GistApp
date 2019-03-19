class AdminController < ApplicationController
  before_action :authenticate_user!
  layout 'application'

  private

  def authenticate_user!
    if current_user != nil
      github = Github.new oauth_token: current_user.github_oauth_token
      scopes = github.scopes.list
      if scopes.join(",") == "gist,user:email"
        true
      else
        session[:user_id] = nil
        redirect_to root_url
      end
    else
      session[:user_id] = nil
      redirect_to root_url
    end
  rescue Exception => e
    session[:user_id] = nil
    redirect_to root_url
  end

end
