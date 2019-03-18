require 'rails_helper'

RSpec.describe History, type: :model do

  it "can be initialized from symbol key hash" do
    current_datetime = DateTime.now
    hash = {
              version: '12225',
              committed_at: current_datetime,
              deletions: 2,
              additions:1,
              total:3,
          }
    
    history = History.new(hash)
    
    expect(history.version).to be       == hash[:version]
    expect(history.committed_at).to be  == hash[:committed_at]
    expect(history.deletions).to be     == hash[:deletions]
    expect(history.additions).to be     == hash[:additions]
    expect(history.total).to be         == hash[:total]
  end

  it "can be initialized from string key hash" do
    current_datetime = DateTime.now
    hash = {
              'version': '12225',
              'committed_at': current_datetime,
              'deletions': 2,
              'additions':1,
              'total':3,
          }
    
    history = History.new(hash)
    
    expect(history.version).to be       == hash[:version]
    expect(history.committed_at).to be  == hash[:committed_at]
    expect(history.deletions).to be     == hash[:deletions]
    expect(history.additions).to be     == hash[:additions]
    expect(history.total).to be         == hash[:total]
  end
end