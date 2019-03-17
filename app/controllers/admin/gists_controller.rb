class Admin::GistsController < AdminController
  layout 'application'

  def index
  end

  def search
    result = Admin::GistFinder.new(current_user,params).list_private
    render json: result.response, each_serializer: Admin::GistSerializer,root:'gists',meta: result.meta[:meta], status: :ok
  end

  def show
    result = Admin::GistFinder.new(current_user,params).find(params[:id])
    render json: result.response, serializer: Admin::GistSerializer,root:'gist', status: :ok
  end

  def new
  end

  def create
    gist = Gist.new(gist_params)
    result = Admin::GistService.new(current_user).create(gist)
    if result.success
      render json: {success:result.success,id:result.response.id}
    else
      render json: {success:result.success,errors:result.errors}
    end
  end

  def edit
    @gist = Admin::GistFinder.new(current_user,params).find(params[:id]).response
  end

  def update
    gist = Gist.new(gist_params)
    result = Admin::GistService.new(current_user).update(gist)
    if result.success
      render json: {success:result.success,id:result.response.id}
    else
      render json: {success:result.success,errors:result.errors}
    end
  end

  def destroy
    result = Admin::GistService.new(current_user).delete(params[:id])
    render json: {success:result.success}
  end 

  private

  def gist_params
    gist_hash = {}

    if params[:gist].present?
      gist_hash[:id] = params[:gist][:id] if  params[:gist][:id].present?
      gist_hash[:description] = params[:gist][:description] if  params[:gist][:description].present?

      if params[:gist][:files].present?
        files = []
        params[:gist][:files].each do |key,value|
         file = {}
         file[:id] = value[:id] if value[:id].present?
         file[:filename] = value[:filename] if value[:filename].present?
         file[:old_filename] = value[:old_filename] if value[:old_filename].present?
         file[:content] = value[:content] if value[:content].present?
         files << file
        end
        gist_hash[:files] = files
      end
    end
    puts gist_hash
    gist_hash
  end

end
