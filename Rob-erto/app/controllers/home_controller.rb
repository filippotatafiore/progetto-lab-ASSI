class HomeController < ApplicationController

  def index
    if session[:first_visit].nil? || session[:first_visit] == true   # primo accesso alla pagina
      reset_session
      session[:first_visit] = false

      # Elimina tutti i base_user che non hanno aggiornato alcuna chat da più di 3 ore
      #User.joins(:chat).where(name: 'base_user').where('chats.updated_at < ?', 3.hours.ago).destroy_all
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
      nuovaChat.save       # Salva la chat nel database

      session[:user_id] = nuovo_base_user.id
      session[:chat_id] = nuovaChat.id
      session[:chat_name] = nuovaChat.nome

      session[:messages] = []
      session[:ai_model] = 'mixtral-8x7b-32768'



    end


    session[:user_name] = User.where('users.id = ?', session[:user_id]).first.nickname
    session[:pro_user_check] = User.where('users.id = ?', session[:user_id]).first.pro


    if session[:user_name] != 'base_user'  # utente loggato

      if session[:primo_accesso_login] == 0   # primo accesso da utente loggato
        session[:primo_accesso_login] = 1
        session[:chat_not_present] = true

      end

      @list_visibility = true    # visibilità della lista chat
      @friendships = Friendship.where(user_id: session[:user_id], status: 1)
      # @friendships = current_user.friendships.where(status: 1)
      @shared_chats = Chat.joins(:shares).where(shares: { destinatario_id: session[:user_id] })

    else
      session[:primo_accesso_login] = 0
      @list_visibility = false
      session[:chat_not_present] = false

    end


    # ---------------- variabili da mostrare nella pagina ----------------
    # mostra la chat nella chat-area
    @chat_not_present = session[:chat_not_present]
    # messaggi da mostrare nella pagina
    @messages = Message.where('chat_id = ?', session[:chat_id]).order(created_at: :asc)
    # nome della chat corrente
    @chat_name = session[:chat_name]
    # nome dell'user corrente
    @user_name = session[:user_name]
    # ruolo user corrente
    @pro_user_check = session[:pro_user_check]
    # modello di IA
    @ai_model = session[:ai_model]
    # lista delle chat dell'utente loggato
    @chats = Chat.where('chats.user_id = ? ', session[:user_id]).order(preferita: :desc)
    # possibilità di scrivere nella chat
    @not_able_to_write = session[:not_able_to_write]
    # ---------------- variabili da mostrare nella pagina ----------------
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
        request["Authorization"] = ENV['API_KEY']


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

        if params[:translate].present? and params[:translate] != "false"
          session[:messages].pop
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


  # ------------------------------------------------------------------ creazione chat
  def new
    @chat = Chat.new
  end

  def create_chat
    chat = Chat.create(user_id: session[:user_id], nome: "Nuova chat")
    chat_id = chat.id
    redirect_to action: :mostra_chat, chat_id: chat_id
  end

  # ------------------------------------------------------------------ mostrare chat
  def mostra_chat
    session[:chat_name] = Chat.where('id = ?', params[:chat_id]).first.nome
    session[:chat_id] = params[:chat_id]
    session[:chat_not_present] = false     # mostra la chat nel chatflow_container

    if params[:condivisa].present? and params[:condivisa] == "true"
      session[:not_able_to_write] = true
    else
      session[:not_able_to_write] = false
    end

    redirect_to action: :index
  end

  # ------------------------------------------------------------------ eliminare chat
  def delete_chat
    @chat = Chat.find(params[:id])
    chat_id = @chat.id
    chat_nome = @chat.nome
    @chat.destroy
    if session[:chat_id] == chat_id || session[:chat_name] == chat_nome     #verifica se hai cancellato la chat che stavi visualizzando
      session[:chat_name] = "Chat cancellata!"
      session[:chat_not_present] = true
    end
    redirect_to action: :index

  end

  # ------------------------------------------------------------------ rinominare chat
  def cambia_nome_chat
    @chat = Chat.where('id = ?', params[:chat_id])
    @chat.update(nome: params[:nome_chat])
    if session[:chat_id].to_s == params[:chat_id]
      session[:chat_name] = params[:nome_chat]
    end
    redirect_to action: :index
  end

  # ------------------------------------------------------------------ inviare domanda suggerita
  def invia_domanda
    # crea la chat
    chat = Chat.create(user_id: session[:user_id], nome: "Nuova chat")
    # mostra la chat
    session[:chat_name] = chat.nome
    session[:chat_id] = chat.id
    session[:chat_not_present] = false     # mostra la chat nel chatflow_container
    # invia la domanda
    params[:user_input] = params[:domanda]
    send_msg
  end

  def aggiungi_ai_preferiti
    @chat = Chat.where('id = ?', params[:chat_id])
    @chat.update(preferita: 1)
    redirect_to action: :index
  end

  def rimuovi_dai_preferiti
    @chat = Chat.where('id = ?', params[:chat_id])
    @chat.update(preferita: 0)
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

  # ------------------------------------------------------------------ condividi chat
  def condividi_chat
    mittente_id = params[:mittente]
    destinatario_id = params[:destinatario]
    chat_id = params[:chat_id]

    # Creazione del nuovo elemento Share
    share = Share.new(user_id: mittente_id, destinatario_id: destinatario_id, chat_id: chat_id)

    if share.save
      # Se il salvataggio va a buon fine, puoi reindirizzare l'utente o renderizzare qualcosa
      redirect_to action: :index, notice: 'Chat condivisa con successo.'
    else
      # Gestisci il caso in cui il salvataggio fallisce (es. mostrando errori)
      render :new, status: :unprocessable_entity
    end
  end

  def rimuovi_chat_condivisa
    #destinatario_id = params[:destinatario]
    chat_id = params[:chat_id]

    # Trova l'elemento Share corrispondente
    share = Share.find_by(destinatario_id: session[:user_id], chat_id: chat_id)

    if share&.destroy
      # Se l'eliminazione va a buon fine, reindirizza o mostra un messaggio di successo
      if session[:chat_id] == chat_id     #verifica se hai cancellato la chat che stavi visualizzando
        session[:chat_name] = "Chat cancellata!"
        session[:chat_not_present] = true
      end
      redirect_to action: :index, notice: 'Chat condivisa rimossa con successo.'
    else
      # Gestisci il caso in cui l'eliminazione fallisce (es. l'elemento non esiste)
      redirect_to action: :index, alert: 'Impossibile rimuovere la chat condivisa.'
    end
  end




end
