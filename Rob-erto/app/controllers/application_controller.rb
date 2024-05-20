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

    # ------------------------------------------------------------------ rende disponibile alcuni metodi di devise alle altre viste
    helper_method :devise_mapping, :resource_class, :resource_name

    def devise_mapping
        Devise.mappings[:user] # or replace :user with whatever model you have
    end

    def resource_class
        devise_mapping.class_name.constantize
    end

    def resource_name
        devise_mapping.name
    end
end
