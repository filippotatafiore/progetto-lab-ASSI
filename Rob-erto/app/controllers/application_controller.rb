class ApplicationController < ActionController::Base
    before_action :set_theme

    # ------------------------------------------------------------------ tema app
    def set_theme
        if params[:theme].present?
            @theme = params[:theme] 
        else
            @theme = 'light'
        end
    end


end
