require 'net/http'
require 'uri'
require 'json'
# API_KEY = "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"

class ApplicationController < ActionController::Base
    before_action :set_theme, :send_msg

    # ------------------------------------------------------------------ tema app
    def set_theme
        if params[:theme].present?
            @theme = params[:theme] 
        else
            @theme = 'light'
        end
    end


    # ------------------------------------------------------------------ send
    def send_msg
        @response = "nada"
        if params[:send].present?
            if params[:send].empty?
                # non fa nulla
            else
                # ---------------- invia messaggio all'AI ----------------

                uri = URI.parse("https://api.groq.com/openai/v1/chat/completions")

                http = Net::HTTP.new(uri.host, uri.port)
                http.use_ssl = true

                request = Net::HTTP::Post.new(uri.request_uri)

                request["Content-Type"] = "application/json"
                request["Authorization"] = "Bearer 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"

                request.body = {
                    "model": "mixtral-8x7b-32768",
                    "messages": []
                }.to_json


                body = JSON.parse(request.body)

                messaggio = params[:send]
                body["messages"].push({"role": "user", "content": messaggio})

                request.body = body.to_json

                response = http.request(request)

                response_obj = JSON.parse(response.body)

                response_obj["choices"].each do |choice|
                    @response = choice["message"]["content"]
                end


                #body = JSON.parse(request.body)

                #messaggio = "what is the last question I asked you?"
                #body["messages"].push({"role": "user", "content": messaggio})

                #request.body = body.to_json

                #response = http.request(request)

                #response_obj = JSON.parse(response.body)

                #response_obj["choices"].each do |choice|
                #    @response = choice["message"]["content"]
                #end

                # ---------------- invia messaggio all'AI ----------------

            end
        else
            #non fa nulla
        end
    end


end
