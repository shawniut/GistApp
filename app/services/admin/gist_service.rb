
class Admin::GistService < Struct.new(:user,:params)
  
  class Result < Struct.new(:success, :errors, :response)
  end

  def initialize(user)
    super(user)
    @gist_client = Github::Client::Gists.new oauth_token: user.github_oauth_token
  end

  def create(gist)
    if gist.valid?
      response = @gist_client.create gist.to_api
      Result.new(true, nil, map_results(response))
    else
      Result.new(false, gist.errors.full_messages, nil)
    end
  rescue Exception => e
    #puts e.message
    #puts e.backtrace
    Result.new(false, [e.message], nil)
  end

  def update(gist)
    if gist.valid?
      response = @gist_client.edit gist.id, gist.to_api
      Result.new(true, nil, map_results(response))
    else
      Result.new(false, gist.errors.full_messages, nil)
    end
  rescue Exception => e
    #puts e.message
    #puts e.backtrace
    Result.new(false, [e.message], nil)
  end

  def create_multiple(gists)
    gists.each do |gist|
      create(gist)
    end
    Result.new(true, nil, nil)
  rescue Exception => e
    #puts e.message
    #puts e.backtrace
    Result.new(false, ["Error creating gists"], nil)
  end

  def delete(id)
    response = @gist_client.delete id
    Result.new(true)
  rescue Exception => e
    #puts e.message
    #puts e.backtrace
    Result.new(false, [e.message], nil)
  end

  private

  def map_results(response)
    gist = Gist.new(id: response.id,public: response.public, description: response.description, created_at: DateTime.parse(response.created_at))
    gist.files = []
    response.files.each do |k,f|
      gist.files <<  GistFile.new(filename:f.filename,language:f.language,type:f.type,size:f.size)
    end
    gist
  end

end



