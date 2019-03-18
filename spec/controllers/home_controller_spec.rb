require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "#index" do
    let(:user) { FactoryGirl.create(:valid_user) }

    context 'when logged in' do
      it "redirects to the gists index page" do
        session[:user_id] = user.id
        get :index
        expect(response).to redirect_to("/admin/gists")
      end
    end

    context 'when logged out' do
      it "redirects to the gists index page" do
        session[:user_id] = nil
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end
