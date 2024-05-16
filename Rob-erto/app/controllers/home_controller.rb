class HomeController < ApplicationController
  #before_action :send_msg

  def index
    #@usr_input = session[:usr_input]
    @response = session[:response]
  end


  # ------------------------------------------------------------------ send
  def send_msg

    session[:response] = "response vuota"
    if params[:user_input].present?

      if params[:user_input].empty?
        session[:usr_input] = "user input vuoto"
        # non fa nulla
        session[:response] = "nada"

      else
        session[:usr_input] = params[:user_input]
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

        messaggio = params[:user_input]
        
        body["messages"].push({"role": "user", "content": messaggio})

        request.body = body.to_json

        response = http.request(request)

        response_obj = JSON.parse(response.body)

        response_obj["choices"].each do |choice|
          session[:response] = choice["message"]["content"]
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
      session[:usr_input] = "non riesco a leggere user input"
      #non fa nulla
    end


    # valori letti dalla funzione js che invoca send_msg
    @usr_input = session[:usr_input]
    render json: { usr_input: @usr_input }

    # reindirizzamento
    #redirect_to action: :index

  end



  # ------------------------------------------------------------------ funzione invocata da javascript il valore di session[:usr_input]
  def get_usr_input
    render json: { usr_input: @usr_input }
  end




end
