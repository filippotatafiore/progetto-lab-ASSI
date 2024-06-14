class AmiciController < ApplicationController
  before_action :set_amico, only: [:show, :edit, :update, :destroy]

  def index
    @friendships = current_user.friendships.where(status: 1)
    @friendship = Friendship.new
  end

  def show
  end

  def new
    @friendship = Friendship.new
  end

  def create
    @friend = User.find_by(email: params[:friendship][:friend_email])
    if @friend
      existing_friendship = Friendship.find_by(user_id: current_user.id, friend_id: @friend.id)
      if existing_friendship
        redirect_to amici_index_path, alert: 'Esiste già una richiesta di amicizia.'
      else
        @friendship = current_user.friendships.build(friend_id: @friend.id, status: 0)

        if @friendship.save
          redirect_to amici_index_path, notice: 'Richiesta di amicizia inviata.'
        else
          redirect_to amici_index_path, alert: @friendship.errors.full_messages.to_sentence
        end
      end
    else
      redirect_to amici_index_path, alert: 'Utente non trovato.'
    end
  end

  def edit
  end

  def update
    if @friendship.update(friendship_params)
      redirect_to amici_path, notice: 'Friendship was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @mirror_friendship = Friendship.find_by(user_id: @friendship.friend_id, friend_id: @friendship.user_id, status: 1)

    if @friendship.destroy
      @mirror_friendship.destroy if @mirror_friendship
      redirect_to amici_index_path, notice: 'Richiesta di amicizia cancellata.'
    else
      redirect_to amici_index_path, alert: 'Si è verificato un errore nel rifiutare la richiesta di amicizia.'
    end
  end

  def accept
    @friendship = Friendship.find(params[:id])
    if @friendship.update(status: 1)
      Friendship.create(user_id: @friendship.friend_id, friend_id: @friendship.user_id, status: 1)
      redirect_to amici_index_path, notice: 'Richiesta di amicizia accettata.'
    else
      redirect_to amici_index_path, alert: 'Si è verificato un errore nell\'accettare la richiesta di amicizia.'
    end
  end

  private

  def set_amico
    @friendship = Friendship.find(params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:friend_id, :status)
  end
end
