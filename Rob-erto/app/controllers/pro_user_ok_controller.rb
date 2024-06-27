class ProUserOkController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:paypal_callback]

  def paypal_callback
    # Qui dovresti verificare il pagamento con PayPal
    # e recuperare l'identificativo dell'utente o un token di sessione precedentemente inviato a PayPal

    session[:verifica_id] = params[:custom_user_id]

    user_id = params[:custom_user_id] # Assicurati che questo parametro venga passato e gestito correttamente
    user = User.find(user_id)

    # Ristabilisci la sessione dell'utente
    sign_in(user)

    redirect_to action: :index, notice: "Pagamento completato con successo!"
  end

  def index
    user = User.find_by(id: session[:user_id])
    if user&.update(pro: true)
      flash[:notice] = "Upgrade a pro effettuato con successo!"
    else
      flash[:alert] = "Si è verificato un errore durante l'upgrade a pro."
    end

    # sleep(3)
    # redirect_to root_path
  end
end
