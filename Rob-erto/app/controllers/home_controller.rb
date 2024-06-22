class HomeController < ApplicationController

  def index
    #@first_visit = 'not first visit'
    
    if session[:first_visit].nil? || session[:first_visit] == true   # primo accesso alla pagina
      reset_session
      session[:first_visit] = false
      #@first_visit = 'first visit'

      # Elimina tutti i base_user che non hanno aggiornato alcuna chat da più di 3 ore
      #User.joins(:chats).where('chats.updated_at < ? AND users.name = ?', 3.hours.ago, 'base_user').destroy_all
      User.where('users.name = ?', 'base_user').destroy_all
      # vengono eliminate di conseguenza tutte le chat associate agli utenti eliminati e tutti i messaggi associati alle chat eliminate

      # ------------------ Crea un nuovo base_user
      nuovo_base_user = User.new
      nuovo_base_user.name = 'base_user'
      nuovo_base_user.email = 'base_user@fake_email'
      nuovo_base_user.password = 'base_user_password'
      nuovo_base_user.save        # Salva l'utente nel database
      # ------------------ Crea nuova chat per il base-user
      nuovaChat = Chat.new
      nuovaChat.user_id = nuovo_base_user.id
      nuovaChat.nome = 'Chatta con AI'
      nuovaChat.save          # Salva la chat nel database

      session[:user_id] = nuovo_base_user.id
      session[:chat_id] = nuovaChat.id
      session[:chat_name] = nuovaChat.nome

      session[:messages] = []
      session[:ai_model] = 'mixtral-8x7b-32768'

    end

    session[:user_name] = User.where('users.id = ?', session[:user_id]).first.name

    if session[:user_name] != 'base_user'  # utente loggato
      @loggato = 'loggato'        # <--DEBUG
      @visibility = true
      #if Chat.where(user_id: session[:user_id]).exists?    # l'utente ha già una o più chat
        # mostrare chat dell'utente loggato
        # TODO ...

      # else
        # creare nuova chat per l'utente loggato

        #nuovaChatLoggato = Chat.new
        #nuovaChatLoggato.user_id = session[:user_id]
        #nuovaChatLoggato.nome = 'Nuova Chat'
        #nuovaChatLoggato.save          # Salva la chat nel database

        #session[:user_name] = User.where('users.id = ?', session[:user_id]).name
        #session[:chat_id] = nuovaChat.id
        #session[:chat_name] = nuovaChat.nome

        #session[:messages] = []

        #@messages = nil

      # end

    else    # condizione di debug, da eliminare
      @loggato = 'non loggato'        # <--DEBUG
      @visibility = false
  
    end


    # ---------------- variabili da mostrare nella pagina ----------------
    # messaggi da mostrare nella pagina
    @messages = Message.where('chat_id = ?', session[:chat_id]).order(created_at: :asc)
    # nome dell'user corrente
    @user_name = session[:user_name]
    # nome della chat corrente
    @chat_name = session[:chat_name]
    # modello di IA
    @ai_model = session[:ai_model]
    # ---------------- variabili da mostrare nella pagina ----------------
    @chats = Chat.where('chats.user_id = ? ', session[:user_id])
  end



  
  # ------------------------------------------------------------------ invio e ricezione messaggi
  def send_msg

    #session[:response] = "response vuota"
    if params[:user_input].present? or params[:reload].present?

      if params[:user_input].empty? and !params[:reload].present?
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

        # gestione reload ultimo messaggio
        if params[:reload].present? and params[:reload] != "false"
          if session[:messages].length > 1
            last_message = session[:messages][-1]
            # invia nuovamente il messaggio
            messaggio = last_message["content"]
            session[:usr_input] = messaggio
            # elimina gli ultimi 2 messaggi
            Message.where(chat_id: session[:chat_id]).order(created_at: :desc).limit(2).destroy_all
          else
            # reindirizzamento (aggiorna la pagina)
            redirect_to action: :index and return
          end
        end

        session[:messages].push({"role": "user", "content": messaggio})

        request.body = {
          "model": session[:ai_model],
          "messages": session[:messages]
        }.to_json


        retries = 2   # numero di tentativi di invio del messaggio
        begin
          response = http.request(request)
        rescue Net::ReadTimeout
          retry if (retries -= 1) > 0   # riprova ancora una volta in caso di errore di timeout nella richiesta http
          redirect_to action: :index and return
        end

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
        user_message.chat_id = session[:chat_id]    # associa il messaggio alla chat corrente
        user_message.save

        # ai_message
        ai_message = Message.new
        ai_message.content = session[:response] # messaggio dell'AI
        ai_message.message_type = 1     # messaggio dalll'AI avrà: message_type = 1
        ai_message.chat_id = session[:chat_id]    # associa il messaggio alla chat corrente
        ai_message.save

        # Aggiorna il timestamp updated_at della chat
        chat = Chat.find(session[:chat_id])
        chat.touch
        # ---------------- salva i due nuovi messaggi come istanze di Message ----------------

      end

    else
      # non fa nulla
      session[:usr_input] = "non riesco a leggere user input"
    end

    # reindirizzamento (aggiorna la pagina)
    redirect_to action: :index and return

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



  def new
    @chat = Chat.new
  end

  def create_chat 
    @chat = Chat.create(user_id: session[:user_id], nome: "Nuova chat")
    redirect_to action: :index
  end

  def mostra_chat
    @message = Message.where('chat_id = ?', params[:chat_id])
    session[:chat_name] = Chat.where('id = ?', params[:chat_id]).first.nome
    session[:chat_id] = params[:chat_id]
    redirect_to action: @chat
  end

  def delete_chat
    @chat = Chat.find(params[:id])
    @chat.destroy
    redirect_to action: :index
  end

  # ------------------------------------------------------------------ cambiare modello di ia
  def set_aimodel

    if params[:ai_model].present?
      if params[:ai_model] == "gemma"
        session[:ai_model] = "gemma-7b-it"

      elsif params[:ai_model] == "llama3-70b"
        session[:ai_model] = "llama3-70b-8192"

      elsif params[:ai_model] == "llama3-8b"
        session[:ai_model] = "llama3-8b-8192"

      else
        session[:ai_model] = "mixtral-8x7b-32768"

      end
    end

    # reindirizzamento (aggiorna la pagina)
    redirect_to action: :index
 
  end




end
