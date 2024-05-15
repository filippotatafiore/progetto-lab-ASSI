require 'net/http'
require 'uri'
require 'json'
# API_KEY = "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"

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
