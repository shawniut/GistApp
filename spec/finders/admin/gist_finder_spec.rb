require 'rails_helper'
require 'spec_helper'

describe Admin::GistFinder do
  let(:user) { FactoryGirl.create(:valid_user) }
  let(:gist1) { FactoryGirl.build(:gist1) }
  let(:finder) { Admin::GistFinder.new(user)}
  let(:service) { Admin::GistService.new(user)}

  it "returns private gists" do 
    service.create(gist1)
    result = finder.list_private
    expect(result.response.size).to be > 0
    expect(result.response[0].public).to be == false
  end

  it "returns stared gists when specified" do 
    gists = finder.list_starred
    expect(gists.size).to be >= 0
  end

  describe "when valid gist id" do 
    it "finds a git details" do 
      gist = service.create(gist1).response
      result = finder.find(gist.id)

      find_gist = result.response
      expect(result.success).to be == true
      expect(find_gist.description).to be == gist.description
      expect(find_gist.comments_count).to be == 0
      expect(find_gist.created_at).not_to be_nil
      expect(find_gist.files.size).to be > 0
      expect(find_gist.files[0].content).to be == gist1.files[0].content
      expect(find_gist.files[0].filename).to be == gist1.files[0].filename
      expect(find_gist.histories.size).to be > 0
    end
  end

  describe "when invalid gist id" do 
    it "finds a git details" do 
      result = finder.find("fsffgsdfgdfsg")
      expect(result.success).to be == false
      expect(result.errors.size).to be > 0
    end
  end

  
end
