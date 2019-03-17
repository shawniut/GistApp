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

  def list_starred!
    response = @gist_client.starred :private, per_page:@per_page, page:@page
    Result.new(true,nil,map_results(response),meta:pagination_dict(response) )
  rescue Exception => e
    return_error_result
  end

  private

  def map_results(response)
    response.map { |g| Gist.new(id: g.id, description: g.description, created_at: DateTime.parse(g.created_at)) }
  end

end
