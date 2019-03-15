class BaseFinder
  
  attr_reader :user, :params

  def initialize(user,params)
    @user  = user
    @params = params
    @page = params[:page] || 1
    @per_page = params[:per_page].to_i == 0 ? 10 : params[:per_page].to_i
  end

end