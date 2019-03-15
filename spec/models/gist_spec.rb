require 'rails_helper'

RSpec.describe Gist, type: :model do
  
  it "can be initialized from hash" do
    current_datetime = DateTime.now
    hash = {id:'12cfdf', description:'My Gist',  created_at: current_datetime}
    
    a_gist = Gist.new(hash)
    
    expect(a_gist.id).to be             == hash[:id]
    expect(a_gist.description).to be    == hash[:description]
    expect(a_gist.created_at).to be     == hash[:created_at]
  end


end