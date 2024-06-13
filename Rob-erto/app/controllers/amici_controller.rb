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
    @friendship = current_user.friendships.build(friend_id: params[:friend_id], status: 0)

    if @friendship.save
      redirect_to amici_index_path, notice: 'Richiesta di amicizia inviata.'
    else
      redirect_to amici_index_path, alert: @friendship.errors.full_messages.to_sentence
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
    @friendship.destroy
    redirect_to amici_path, notice: 'Richiesta di amicizia rifiutata.'
  end

  def accept
    @friendship = Friendship.find(params[:id])
    @friendship.update(status: 1)
    redirect_to amici_path, notice: 'Richiesta di amicizia accettata.'
  end

  private

  def set_amico
    @friendship = Friendship.find(params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:friend_id, :status)
  end
end
