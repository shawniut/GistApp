require 'rails_helper'

RSpec.describe Admin::GistsController, type: :controller do

  let(:user) { FactoryGirl.create(:valid_user) }

  before do
    session[:user_id] = user.id
    service = Admin::GistService.new(user)
    @gist1 = service.create(Gist.new(description:'Test Gist 1',files:[{filename:'a.txt',content:'sdfsdf'}])).response
    @gist2 = service.create(Gist.new(description:'Test Gist 1',files:[{filename:'a.txt',content:'sdfsdf'}])).response

  end

  describe "#index" do
    it "renders gist index page" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "#new" do
    it "renders create new gist page" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#search" do
    it "returns json response" do
      get :search
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it "returns http status OK" do
      get :search
      expect(response).to have_http_status(:ok)
    end

    it "returns gists by paginition" do
      get :search, params: {page:1,per_page:1}
      json_body = JSON.parse(response.body)
      expect(json_body["gists"].size).to be == 1
    end

    it "returns starred gists when specified" do
      get :search, params: {page:1,per_page:1,stared:'true'}
      json_body = JSON.parse(response.body)
      expect(json_body["gists"][0]['description']).to be == "Test Start"
    end

    describe "#index" do
      it "renders gist index page" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe "#edit" do
      it "renders edit view when valid gist id is specified" do
        get :edit, params:{id: @gist1.id}
        expect(response).to render_template(:edit)
      end
      it "redirects to the root url when invalid gist id is specified" do
        get :edit, params:{id:'daab9ea77ae801b5c01ef4aea4a858e9sdf'}
        expect(response).to redirect_to root_url
      end
    end

    describe "#destroy" do
      it "returns success when valid gist id is specified" do
        delete :destroy, params:{id:@gist2.id}
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to be == true
      end
      it "returns success false when invalid gist id is specified" do
        delete :destroy, params:{id:"sdfsdfsdfsdf"}
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to be == false
      end
    end

  end
end
