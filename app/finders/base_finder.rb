class BaseFinder
  
  attr_reader :user, :params

  class Result < Struct.new(:success, :errors, :response,:meta)
  end

  def initialize(user,params)
    @user  = user
    @params = params
    @page = params[:page] || 1
    @per_page = params[:per_page].to_i == 0 ? 2 : params[:per_page].to_i
  end

  def pagination_dict(response)
    total_count = response.count

    count_pages = response.count_pages
    if count_pages > 0
      last_page_count = response.page(response.count_pages).count
      total_count = ((count_pages-1) * @per_page) + last_page_count
    end
    
    {
      current_page: @page,
      total_count: total_count
    }
  end

  def return_error_result
    Result.new(false,[e.message],nil,nil)
  end

end