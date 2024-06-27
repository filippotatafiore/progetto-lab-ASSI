class ProfiloController < ApplicationController
  def index
    session[:pro_user_check] = User.where('users.id = ?', session[:user_id]).first.pro
    @pro_user_check = session[:pro_user_check]
  end


  def update_profile_image
    @user = current_user
    if @user.update(profile_image: params[:image])
      render json: { message: 'Immagine profilo caricata' }
    else
      render json: { error: 'Errore durante il caricamento dell\'immagine del profilo' }, status: :unprocessable_entity
    end
  end
end
