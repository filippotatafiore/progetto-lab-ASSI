require 'net/http'
require 'uri'
require 'json'
# API_KEY = "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"

class ApplicationController < ActionController::Base
    before_action :set_theme

    # ------------------------------------------------------------------ tema app
    def set_theme
        @theme = session[:theme] || 'light'
    end

    def change_theme
        if params[:theme].present?
            session[:theme] = params[:theme]
        else
            session[:theme] = 'light'
        end
        redirect_back(fallback_location: root_path)
    end

    # ------------------------------------------------------------------ rende disponibile alcuni metodi di devise alle altre viste
    helper_method :devise_mapping, :resource_class, :resource_name
    protect_from_forgery with: :exception

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
