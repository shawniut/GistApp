require 'rails_helper'

RSpec.describe GistFile, type: :model do
  let(:file1) { FactoryGirl.build(:file1) }

  it "can be initialized from hash" do
    current_datetime = DateTime.now
    hash = {
              id: '12225',
              filename: 'a.txt',
              old_filename: 'b.txt',
              content:'sdasdasd',
              language:'Text',
              size:12,
              created_at: current_datetime,
              updated_at: current_datetime,

          }
    
    file = GistFile.new(hash)
    
    expect(file.id).to be             == hash[:id]
    expect(file.filename).to be       == hash[:filename]
    expect(file.old_filename).to be   == hash[:old_filename]
    expect(file.content).to be        == hash[:content]
    expect(file.language).to be       == hash[:language]
    expect(file.size).to be           == hash[:size]
    expect(file.created_at).to be     == hash[:created_at]
    expect(file.updated_at).to be     == hash[:updated_at]
  end

  it "is not valid without a filename" do
    file = GistFile.new
    expect(file).to_not be_valid
  end

  describe "#to_api" do
    it 'returns correct hash to update a file name and its content' do
      file1.old_filename = 'old.txt'
      hash = file1.to_api
      expect(hash).to be == {"old.txt" => {filename: file1.filename, content: file1.content}}
    end

    it 'returns correct hash to delete a file' do
      file1.old_filename = nil
      file1.content = nil
      hash = file1.to_api
      expect(hash).to be == {"#{file1.filename}" => nil}
    end

    it 'returns correct hash to create a file' do
      file1.old_filename = nil
      file1.content = "adsfsfsdf"
      hash = file1.to_api
      expect(hash).to be == {"#{file1.filename}" => {content: file1.content}}
    end

  end
end