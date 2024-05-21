class HomeController < ApplicationController

  def index
    if session[:first_visit].nil?   # prima volta che si accede alla pagina
      Message.destroy_all
      session[:first_visit] = false

      session[:messages] = []
    end

    #Message.destroy_all
    @messages = Message.order(created_at: :asc)

  end



  
  # ------------------------------------------------------------------ invio e ricezione messaggi
  def send_msg

    #session[:response] = "response vuota"
    if params[:user_input].present?

      if params[:user_input].empty?
        # non fa nulla
        #session[:usr_input] = "user input vuoto"
        #session[:response] = "nada"

      else
        session[:usr_input] = params[:user_input]
        # ---------------- invia messaggio all'AI ----------------

        uri = URI.parse("https://api.groq.com/openai/v1/chat/completions")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.request_uri)

        request["Content-Type"] = "application/json"
        request["Authorization"] = "Bearer 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"


        messaggio = params[:user_input]     # messaggio da inviare
        
        # gestione traduzioni
        if params[:translate].present? and params[:translate] != "false"
          messaggio = "Translate the following text in " + params[:translate] + ": " + messaggio
        end

        session[:messages].push({"role": "user", "content": messaggio})

        request.body = {
          "model": "mixtral-8x7b-32768",
          "messages": session[:messages]
        }.to_json

        response = http.request(request)

        response_obj = JSON.parse(response.body)

        if response_obj["choices"]
          response_obj["choices"].each do |choice|
            session[:response] = choice["message"]["content"]
          end
        else
          session[:response] = "Sto avendo dei problemi in questo momento. Prova a inviare nuovamente il messaggio."
        end

        # ---------------- invia messaggio all'AI ----------------


        # ---------------- salva i due nuovi messaggi come istanze di Message ----------------
        # user_message
        user_message = Message.new
        user_message.content = session[:usr_input] # messaggio dell'utente
        user_message.message_type = 0     # messaggio utente avrà: message_type = 0
        user_message.save

        # ai_message
        ai_message = Message.new
        ai_message.content = session[:response] # messaggio dell'AI
        ai_message.message_type = 1     # messaggio dalll'AI avrà: message_type = 1
        ai_message.save
        # ---------------- salva i due nuovi messaggi come istanze di Message ----------------

      end

    else
      # non fa nulla
      session[:usr_input] = "non riesco a leggere user input"
    end

    # reindirizzamento (aggiorna la pagina)
    redirect_to action: :index

  end



  # ------------------------------------------------------------------ eliminare messaggi
  def delete_message
    @message = Message.find(params[:id])
    @next_message = Message.where("id > ?", params[:id]).first

    @message.destroy
    @next_message.destroy if @next_message

    # reindirizzamento (aggiorna la pagina)
    redirect_to action: :index
  end

end
