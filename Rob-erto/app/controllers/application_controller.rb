class ApplicationController < ActionController::Base
    def index
        # ------------------------------------------------tema app
        if params[:theme].present?
            @theme = params[:theme] 
        else
            @theme = 'light'
        end
    end

end
