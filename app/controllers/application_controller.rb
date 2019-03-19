class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  protect_from_forgery with: :exception
  helper_method :current_user
 
  private
 
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => 'application', :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def redirect_to_root_url
    redirect_to root_url && return
  end
  
end
