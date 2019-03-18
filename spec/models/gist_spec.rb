require 'rails_helper'

RSpec.describe Gist, type: :model do

  let(:user) { FactoryGirl.create(:valid_user) }
  let(:gist1) { FactoryGirl.build(:gist1) }
  
  it "can be initialized from hash" do
    current_datetime = DateTime.now
    hash = {
              id:'12cfdf',
              description:'My Gist',
              created_at: current_datetime,
              updated_at: current_datetime,
              comments_count: 3,
              files:[
                {filename: 'a.txt', content:'sdasdasd'}
              ]
          }
    
    a_gist = Gist.new(hash)
    
    expect(a_gist.id).to be             == hash[:id]
    expect(a_gist.description).to be    == hash[:description]
    expect(a_gist.created_at).to be     == hash[:created_at]
    expect(a_gist.updated_at).to be     == hash[:updated_at]
    expect(a_gist.comments_count).to be == hash[:comments_count]
    expect(a_gist.files.size).to be     == hash[:files].size
  end

  it "is not valid without a description" do
    gist = Gist.new
    expect(gist).to_not be_valid
  end

  describe '#to_api' do
    it "converts the gist to a valid githib api params with merging files" do
      github_api_params = gist1.to_api
      expect(github_api_params[:description]).to be gist1.description
      expect(github_api_params[:files]).to include({"#{gist1.files[0].filename}" => {:content=>gist1.files[0].content}})
      expect(github_api_params[:files]).to include({"#{gist1.files[1].filename}" => {:content=>gist1.files[1].content}})
    end
  end

  describe "build gist from response" do
    it  'builds gist from response' do
      github = Github::Client::Gists.new oauth_token: user.github_oauth_token
      response = github.create gist1.to_api
      gist = Gist.new
      gist.build_from_response(response)
      expect(gist.description).not_to be_nil
      expect(gist.id).to be == response.id
      expect(gist.comments_count).to be == 0
      expect(gist.created_at).not_to be_nil
      expect(gist.updated_at).not_to be_nil
      expect(gist.files.size).to be == 2
      expect(gist.histories.size).to be == 1
    end
  end

end