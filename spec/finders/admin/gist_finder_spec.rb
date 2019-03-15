require 'rails_helper'
require 'spec_helper'

describe Admin::GistFinder do
  let(:user) { FactoryGirl.create(:valid_user) }

  it "should return gists" do 
    finder = Admin::GistFinder.new(user)
    gists = finder.list_private
    expect(gists.size).to be > 0
  end

end
