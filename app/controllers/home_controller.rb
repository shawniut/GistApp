class HomeController < ApplicationController
  layout 'application'

  def index
    if current_user
      redirect_to admin_gists_path
    end
  end
end
