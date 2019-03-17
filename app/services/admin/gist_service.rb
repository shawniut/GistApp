
class Admin::GistService < Struct.new(:user,:params)
  
  class Result < Struct.new(:success, :errors, :response)
  end

  def initialize(user)
    super(user)
    @gist_client = Github::Client::Gists.new oauth_token: user.github_oauth_token
  end

  def create(params)
    gist = Gist.new(params)
    if gist.valid?
      puts gist.to_api
      response = @gist_client.create gist.to_api
      Result.new(true, nil, response)
    else
      Result.new(false, gist.errors, map_results(response))
    end
  rescue Exception => e
    puts e.message
    puts e.backtrace
    Result.new(false, e.message, nil)
  end

  def create_multiple(params)
    return Result.new(false, "Invalid values", nil) unless check_params(params)
    params.each do |param_value|
      create(param_value)
    end
    Result.new(true, nil, nil)
  rescue Exception => e
    puts e.message
    puts e.backtrace
    Result.new(false, "Error creating gists", nil)
  end

  private

  def check_params(params)
    params.each do |param_value|
      gist = Gist.new(param_value)
      return false unless gist.valid?
    end
    true
  rescue Exception => e
    false
  end

  def map_results(response)
    gist = response.map { |g| Gist.new(id: g.id, description: g.description, created_at: DateTime.parse(g.created_at)) }
    gist.files = response.files.map { |f| GistFile.new(filename:f.filename,language:f.language,type:f.type,size:f.size) }
  end

end



