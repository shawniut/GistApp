require 'rails_helper'
require 'spec_helper'

describe Admin::GistFinder do
  let(:user) { FactoryGirl.create(:valid_user) }
  let(:ivalid_user) { FactoryGirl.create(:invalid_user) }

  context "when valid github user" do
    it "returns private gists" do 
      finder = Admin::GistFinder.new(user)
      gists = finder.list_private!
      expect(gists.size).to be > 0
    end

    it "returns stared gists" do 
      finder = Admin::GistFinder.new(user)
      gists = finder.list_starred!
      expect(gists.size).to be >= 0
    end
  end

  context "when invalid github user" do
    it "raises unauthorized error" do 
      finder = Admin::GistFinder.new(ivalid_user)
      expect {finder.list_private!}.to raise_error Github::Error::Unauthorized
    end
  end

end
