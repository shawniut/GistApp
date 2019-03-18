class Admin::GistFinder < BaseFinder
  def initialize(user,params={})
    super(user,params)
    @gist_client = Github::Client::Gists.new oauth_token: user.github_oauth_token
  end

  def list_private
    response = @gist_client.list :private, per_page:@per_page, page:@page
    Result.new(true,nil,map_results(response),meta:pagination_dict(response) )
  rescue Exception => e
    return_error_result
  end

  def list_starred
    response = @gist_client.starred :private, per_page:@per_page, page:@page
    Result.new(true,nil,map_results(response),meta:pagination_dict(response) )
  rescue Exception => e
    return_error_result(e)
  end

  def find(id)
    response = @gist_client.get id
    gist = Gist.new
    gist.build_from_response(response)
    Result.new(true,nil,gist)
  rescue Exception => e
    return_error_result(e)
  end


  private

  def map_results(response)
    response.map { |gits|  map_gist(gits)}
  end

  def map_gist(response)
    gist = Gist.new(id: response.id,public: response.public, comments_count:response.comments, description: response.description, created_at: DateTime.parse(response.created_at))
    gist.files = []
    response.files.each do |k,f|
      gist.files <<  GistFile.new(filename:f.filename,language:f.language,type:f.type,size:f.size)
    end
    gist
  end

end
