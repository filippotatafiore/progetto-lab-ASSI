class UsersController < ApplicationController
  def update_nickname
    current_user.update(nickname: params[:user][:nickname])
    redirect_to root_path, notice: 'Nickname aggiornato con successo.'
  end
end
