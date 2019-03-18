require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
  end

  describe "POST #create" do
    
    it "creates a new user" do
      expect {
        post :create
      }.to change{ User.count }.by(1)
    end
    
    it "creates a session" do
      expect(session[:user_id]).to be_nil
      post :create
      expect(session[:user_id]).not_to be_nil
    end

    it "redirects the user to the gist index" do
      post :create
      expect(response).to redirect_to root_url
    end

  end

  describe "#destroy" do
    before do
      post :create
    end
 
    it "clears the session" do
      expect(session[:user_id]).not_to be_nil
      delete :destroy
      expect(session[:user_id]).to be_nil
    end
 
    it "redirects to the app home page" do
      delete :destroy
      expect(response).to redirect_to root_url
    end
  end

end
