class Admin::GistsController < AdminController
  layout 'application'

  def index
  end

  def search
    result = Admin::GistFinder.new(current_user,params).list_private
    puts result.inspect
    render json: result.response, each_serializer: Admin::GistSerializer,root:'gists',meta: result.meta, status: :ok
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destory
  end 

end
