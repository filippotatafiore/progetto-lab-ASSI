class ProUserOkController < ApplicationController
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
