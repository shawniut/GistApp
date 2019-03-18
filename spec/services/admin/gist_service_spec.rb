require 'rails_helper'
require 'spec_helper'

describe Admin::GistService do
  let(:user) { FactoryGirl.create(:valid_user) }
  let(:gist_service) { Admin::GistService.new(user) }
  let(:gist_finder) { Admin::GistFinder.new(user) }
  let(:multiple_file_gist) { FactoryGirl.build(:gist1) }
  let(:single_file_gist) { FactoryGirl.build(:single_file_gist) }
  let(:invalid_file_gist) { FactoryGirl.build(:invalid_file_gist) }

  describe '#create' do
    
    context 'valid gist is provided' do
      it 'adds a new gist' do
        result = gist_service.create(single_file_gist)
        expect(result.success).to be true
        expect(result.response.files.size).to be == 1
        expect(result.errors).to be_nil
      end

      it 'adds a new gist with multiple files' do
        result = gist_service.create(multiple_file_gist)
        expect(result.success).to be true
        expect(result.response.files.size).to be == 2
        expect(result.errors).to be_nil
      end
    end

    context 'Invalid gist is provided' do
      it 'returns validation errors when gist desciption is not provided' do
        result = gist_service.create(Gist.new)
        expect(result.success).to be false
        expect(result.response).to be_nil
        expect(result.errors).to include("Description can't be blank")
      end
    end
  end

  describe '#create_multile' do
    context 'when valid gists are specified' do
      it 'returns success' do
        result = gist_service.create_multiple([single_file_gist, multiple_file_gist])
        expect(result.success).to be true
        expect(result.errors).to be_nil
      end
    end
  end

  describe '#update' do
    
    context 'valid gist is provided' do
      it 'updates gist description and its files content' do
        gist = gist_service.create(single_file_gist).response
        gist.description = "Updated content"
        gist.files[0].old_filename = gist.files[0].filename
        gist.files[0].filename = "u.txt"
        gist.files[0].content = "updated content"

        updated_gist = gist_service.update(gist).response

        updated_gist_details =  gist_finder.find(updated_gist.id).response

        expect(updated_gist_details.description).to be == "Updated content"
        expect(updated_gist_details.files[0].filename).to be == "u.txt"
        expect(updated_gist_details.files[0].content).to be == "updated content"
      end

      it 'deletes a file when content is nil' do
        gist1 = FactoryGirl.build(:gist1)
        gist1 = gist_service.create(gist1).response

        gist_details =  gist_finder.find(gist1.id).response
        gist_details.files[1].content = nil
        
        updated_gist = gist_service.update(gist_details).response
        expect(updated_gist.files.size).to be == (gist_details.files.size -  1)
      end
    end

    context 'Invalid gist is provided' do
      it 'returns validation errors when gist desciption is not provided' do
        result = gist_service.update(Gist.new)
        expect(result.success).to be false
        expect(result.response).to be_nil
        expect(result.errors).to include("Description can't be blank")
      end
    end
  end

  describe '#delete' do
    context 'when valid gist id specified' do
      it 'deletes a gist' do
        gist1 = FactoryGirl.build(:gist1)
        gist1 = gist_service.create(gist1).response

        result =  gist_service.delete(gist1.id)
        
        expect(result.success).to be true
        expect(result.errors).to be_nil

        result =  gist_service.delete(gist1.id)
        expect(result.success).to be false
        expect(result.errors).not_to be_nil
      end
    end

    context 'when invalid gist id specified' do
      it 'can not delete the gist' do
        result =  gist_service.delete("dfsdfsdfsf")      
        expect(result.success).to be false
        expect(result.errors).not_to be_nil
      end
    end
  end

end