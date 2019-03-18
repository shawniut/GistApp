require 'rails_helper'

RSpec.describe Admin::GistsController, type: :controller do

  let(:user) { FactoryGirl.create(:valid_user) }
  let(:gist1) { FactoryGirl.build(:gist1) }
  let(:gist2) { FactoryGirl.build(:gist2) }

  before do
    session[:user_id] = user.id
    @service = Admin::GistService.new(user)
  end


  describe "#index" do
    it "renders gist index page" do
      get :index
      expect(response).to render_template(:index)
    end

    it "redirects to the root url when authentication fails" do
      session[:user_id] = nil
      get :index
      expect(response).to redirect_to(root_url)
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
      @service.create(gist1)
      @service.create(gist2)
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
        gist = @service.create(gist1).response
        get :edit, params:{id: gist.id}
        expect(response).to render_template(:edit)
      end
      it "redirects to the root url when invalid gist id is specified" do
        get :edit, params:{id:'daab9ea77ae801b5c01ef4aea4a858e9sdf'}
       expect(response).to have_http_status(:not_found)
      end
    end

    describe "#create" do
      it "returns gist id when valid params are specified" do
        post :create, params:{"gist"=>{"description"=>"My Gist", "files"=>{"0"=>{"filename"=>"a.txt", "content"=>"fsdfsg"}}}}
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to be == true
        expect(json_body["id"]).not_to be_nil
        expect(response).to have_http_status(:ok)
      end

      it "returns false when error occured" do
        post :create, params:{id:'daab9ea77ae801b5c01ef4aea4a858e9sdf'}
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to be == false
        expect(response).to have_http_status(:bad_request)
      end
    end

    describe "#update" do
      it "returns success when valid params are specified" do
        gist = @service.create(gist2).response
        patch :update, params:{id:gist.id, gist:{id:gist.id, description:"Updated Gist", files:{"0" => {old_filename: "file2.txt",filename: "update.txt", content: "updated_content"}}}}
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to be == true
        expect(json_body["id"]).not_to be_nil
        expect(response).to have_http_status(:ok)
      end

      it "returns bad request when params invalid" do
        patch :update, params:{id:'daab9ea77ae801b5c01ef4aea4a858e9sdf'}
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to be == false
        expect(response).to have_http_status(:bad_request)
      end
    end

    describe "#destroy" do
      it "returns success when valid gist id is specified" do
        gist = @service.create(gist1).response
        delete :destroy, params:{id:gist.id}
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
