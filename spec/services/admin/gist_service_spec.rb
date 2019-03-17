require 'rails_helper'
require 'spec_helper'

describe Admin::GistService do
  let(:user) { FactoryGirl.create(:valid_user) }
  let(:gist_service) { Admin::GistService.new(user) }
  let(:params) { {description: 'Test Gist', files: [{filename:"test.txt", content: 'Test content'}] }}
  let(:params_multiple_file) { 
        {
          description: 'Test Gist', 
          files: 
          [
            {filename:"test1.txt", content: 'Test1 content'},
            {filename:"test2.txt", content: 'Test2 content'}
          ] 
        }
        }

  describe '#create' do
    
    context 'when params are valid' do
      it 'adds a new gist' do
        result = gist_service.create(params)
        expect(result.success).to be true
        expect(result.response.files.size).to be == 1
        expect(result.errors).to be_nil
      end

      it 'adds a new gist with multiple files' do
        result = gist_service.create(params_multiple_file)
        expect(result.success).to be true
        expect(result.response.files.size).to be == 2
        expect(result.errors).to be_nil
      end
    end
  end


  describe '#create_multile' do
    
    context 'when params are valid' do
      it 'returns success' do
        result = gist_service.create_multiple([params, params_multiple_file])
        expect(result.success).to be true
        expect(result.errors).to be_nil
      end
    end
  end



end