module Admin
  class Admin::GistService << Struct.new(:user)
    
    class Result < Struct.new(:success, :errors, :result)
    end

    def list_private
    end

    def list_starred
    end

  end
end


